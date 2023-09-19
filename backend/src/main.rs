mod chat_room;
mod list;

use std::sync::{Arc, Mutex};

use warp::Filter;
use warp::ws::{Ws, WebSocket};

use chat_room::ChatRoom;
use list::List;

async fn send_to_chatroom(ws: WebSocket, room_id: usize, rooms: Arc<Mutex<List<ChatRoom>>>) {
    let mut rs = rooms.lock().unwrap();
    if let Some(r) = rs.iter_mut().find(|r| r.id() == room_id) {
        r.push_connection(ws);
    }
}

// https://github.com/seanmonstar/warp/issues/729

#[tokio::main]
async fn main() {
    let rooms = Arc::new(Mutex::new(List::new()));

    let cors = warp::cors()
        .allow_any_origin()
        .allow_headers(vec!["Access-Control-Allow-Origin", "Origin", ""])
        .allow_methods(vec!["GET"]);
    
    let rooms_clone = rooms.clone();
    let new_room = warp::path("new_room")
        .map(move || {
            let mut r = rooms_clone.lock().unwrap();
            let room_id = r.len();
            r.push(ChatRoom::new(room_id));
            println!("current rooms: {}", room_id+1);
            warp::reply::json(&"yo")
        });

    let rooms_clone = rooms.clone();
    let can_join = warp::path!("can_join" / usize)
        .map(move |room_id: usize| {
            let rs = rooms_clone.lock().unwrap();
            let b = match rs.iter().find(|r| r.id() == room_id) {
                Some(r) => r.has_room(),
                None => false
            };
            warp::reply::json(&b)
        });

    let rooms_clone = warp::any().map(move || rooms.clone());
    let join = warp::path!("join" / usize)
        .and(warp::ws())
        .and(rooms_clone)
        .map(|room_id: usize, ws: Ws, rooms| {
            ws.on_upgrade(move |socket| send_to_chatroom(socket, room_id, rooms))
        });

    let routes = join
        .or(new_room)
        .or(can_join);

    warp::serve(routes)
        .run(([127, 0, 0, 1], 8080))
        .await;
}
