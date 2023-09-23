mod chat_room;
mod user;

use std::sync::{Arc, RwLock};
use std::collections::HashMap;

use warp::Filter;
use warp::ws::{Ws, WebSocket};

use chat_room::{ChatRoom, Rooms};

async fn send_to_chatroom(ws: WebSocket, room_id: usize, rooms: Rooms) {
    let rs = rooms.read().unwrap();
    if let Some(r) = rs.get(&room_id) {
        ChatRoom::push_connection(r.clone(), ws);
    }
}

// https://github.com/seanmonstar/warp/issues/729

#[tokio::main]
async fn main() {
    let rooms: Rooms = Arc::new(RwLock::new(HashMap::new()));

    let cors = warp::cors()
        .allow_any_origin()
        .allow_headers(vec!["Access-Control-Allow-Origin", "Origin"])
        .allow_methods(vec!["GET"]);
    
    let rooms_clone = rooms.clone();
    let new_room = warp::path("new_room")
        .map(move || {
            let r = rooms_clone.clone();
            let room_id = r.read().unwrap().len();
            r.write().unwrap().insert(room_id, Arc::new(RwLock::new(ChatRoom::new(room_id))));
            println!("current rooms: {}", room_id+1);
            warp::reply::json(&room_id)
        })
        .with(&cors);

    let rooms_clone = rooms.clone();
    let can_join = warp::path!("can_join" / usize)
        .map(move |room_id: usize| {
            let rs = rooms_clone.read().unwrap();
            let b = match rs.get(&room_id) {
                Some(r) => r.read().unwrap().has_room(),
                None => false
            };
            warp::reply::json(&b)
        })
        .with(&cors);

    let rooms_clone = warp::any().map(move || rooms.clone());
    let join = warp::path!("join" / usize)
        .and(warp::ws())
        .and(rooms_clone)
        .map(|room_id: usize, ws: Ws, rooms: Rooms|
            ws.on_upgrade(move |socket| send_to_chatroom(socket, room_id, rooms))
        );

    let routes = join
        .or(new_room)
        .or(can_join);

    warp::serve(routes)
        .run(([127, 0, 0, 1], 8080))
        .await;
}
