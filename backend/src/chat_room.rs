use std::sync::{Arc, RwLock};
use std::collections::HashMap;

use warp::filters::ws::WebSocket;
use warp::ws::Message;
use futures::stream::{StreamExt, SplitStream};
use futures::SinkExt;
use tokio::sync::mpsc::{UnboundedSender, unbounded_channel};
use tokio_stream::wrappers::UnboundedReceiverStream;

pub type Rooms = Arc<RwLock<HashMap<usize, Arc<RwLock<ChatRoom>>>>>;
type Connections = Arc<RwLock<HashMap<usize, UnboundedSender<Message>>>>;

#[derive(Debug)]
pub struct ChatRoom {
    id: usize,
    cap: usize,
    connections: Connections
}

impl ChatRoom {
    pub fn new(id: usize) -> Self {
        Self { 
            id, 
            cap: 5, 
            connections: Arc::new(RwLock::new(HashMap::new()))
        }
    }

    pub fn has_room(&self) -> bool {
        self.connections.read().unwrap().len() < self.cap
    }

    fn broadcast(connections: Connections, msg: Message) {
        let mut cs = connections.write().unwrap();
        cs.iter_mut().for_each(|(_, c)| {
            c.send(msg.clone())
                .unwrap_or_else(|e| {
                    eprintln!("error sending message: {}", e);
                });
        });
    }

    async fn handle_user_messages(user_id: usize, connections: Connections, mut rx: SplitStream<WebSocket>) {
        println!("{} joined", user_id);
        Self::broadcast(connections.clone(), Message::text(format!("User {} joined chat", user_id)));

        while let Some(result) = rx.next().await {
            match result {
                Ok(msg) => {
                    if let Ok(s) = msg.to_str() {
                        let msg = format!("User {}: {}", user_id, s);
                        Self::broadcast(connections.clone(), Message::text(msg));
                    }
                },
                Err(e) => {
                    eprintln!("websocket error: {}", e);
                    break;
                }
            }
        }

        connections.write().unwrap().remove(&user_id);
        Self::broadcast(connections.clone(), Message::text(format!("User {} left the chat", user_id)));
        println!("{} left", user_id);
    }

    pub fn push_connection(room: Arc<RwLock<ChatRoom>>, ws: WebSocket) {
        static mut USER_ID: usize = 0;

        let (mut ws_tx, ws_rx) = ws.split();
        let (tx, rx) = unbounded_channel();
        let mut rx = UnboundedReceiverStream::new(rx);

        tokio::task::spawn(async move {
            while let Some(message) = rx.next().await {
                ws_tx
                    .send(message)
                    .await
                    .unwrap_or_else(|e| {
                        eprintln!("websocket: {}", e);
                    });
            }
        });

        // safe because: trust me bro
        let user_id = unsafe {
            let c = room.read().unwrap();
            c.connections
                .write()
                .unwrap()
                .insert(USER_ID, tx);
            USER_ID += 1;
            USER_ID - 1
        };

        let cs = room.read().unwrap().connections.clone();
        tokio::task::spawn(async move {
            Self::handle_user_messages(user_id, cs, ws_rx).await;
        });
    }
}
