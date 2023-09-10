use std::sync::{Arc, Mutex};

use warp::filters::ws::WebSocket;
use warp::ws::Message;
use futures::stream::{StreamExt, SplitStream};
use futures::SinkExt;
use tokio::sync::mpsc::{UnboundedSender, unbounded_channel};
use tokio_stream::wrappers::UnboundedReceiverStream;

use crate::list::List;

#[derive(Debug)]
pub struct User {
    id: usize,
    name: String,
    sender: UnboundedSender<Message>
}

impl User {
    fn new(id: usize, sender: UnboundedSender<Message>) -> Self {
        Self {
            id,
            name: String::from("yo"),
            sender
        }
    }
}

#[derive(Debug)]
pub struct ChatRoom {
    id: usize,
    cap: usize,
    len: usize,
    connections: Arc<Mutex<List<User>>>
}

impl ChatRoom {
    pub fn new(id: usize) -> Self {
        Self { 
            id, 
            cap: 5, 
            len: 0,
            connections: Arc::new(Mutex::new(List::new()))
        }
    }

    pub fn id(&self) -> usize {
        self.id
    }

    pub fn has_room(&self) -> bool {
        self.len < self.cap
    }

    fn broadcast(connections: Arc<Mutex<List<User>>>, msg: Message) {
        let mut cs = connections.lock().unwrap();
        cs.iter_mut().for_each(|c| {
            c.sender.send(msg.clone())
                .unwrap_or_else(|e| {
                    eprintln!("error sending message: {}", e);
                });
        });
    }

    async fn handle_user_messages(
        user_id: usize,
        connections: Arc<Mutex<List<User>>>, 
        mut rx: SplitStream<WebSocket>
    ) {
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

        let mut cs = connections.lock().unwrap();
        cs.retain(|c| c.id != user_id);
        Self::broadcast(connections.clone(), Message::text(format!("User {} left the chat", user_id)));
    }

    pub fn push_connection(&mut self, ws: WebSocket) {
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

        let mut c = self.connections.lock().unwrap();

        // safe because: trust me bro
        let user_id = unsafe {
            c.push(User::new(USER_ID, tx));
            self.len += 1;
            USER_ID += 1;
            USER_ID - 1
        };

        let cs = self.connections.clone();
        tokio::task::spawn(async move {
            Self::handle_user_messages(user_id, cs, ws_rx).await;
        });
    }
}
