CREATE TABLE Contacts (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE,
    status TEXT,
    photo TEXT,
    isOnline BOOLEAN
);

CREATE TABLE Friend (
    user_id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT NOT NULL UNIQUE,
    display_name TEXT,
    avatar_url TEXT
);

CREATE TABLE Conversations (
    conversation_id INTEGER PRIMARY KEY AUTOINCREMENT,
    friend_id INTEGER,
    FOREIGN KEY (remote_user_id) REFERENCES RemoteUsers(user_id)
);

CREATE TABLE Messages (
    message_id INTEGER PRIMARY KEY AUTOINCREMENT,
    conversation_id INTEGER,
    is_from_local_user BOOLEAN,
    content TEXT NOT NULL,
    timestamp DATETIME NOT NULL,
    FOREIGN KEY (conversation_id) REFERENCES Conversations(conversation_id)
);
