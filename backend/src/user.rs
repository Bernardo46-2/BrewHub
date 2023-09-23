use std::sync::{Arc, RwLock};
use std::collections::HashMap;

pub type Users = Arc<RwLock<HashMap<usize, User>>>;

pub struct User {
    id: usize
}

impl User {
    pub fn new(id: usize) -> Self {
        Self { id }
    }
}
