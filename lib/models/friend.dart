import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class Friend with ChangeNotifier {
  final int id;
  final String name;
  final String status;
  final String photo;
  bool isOnline;

  Friend({
    required this.id,
    required this.name,
    required this.status,
    required this.photo,
    required this.isOnline,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'photo': photo,
      'isOnline': isOnline ? 1 : 0
    };
  }

  Map<String, Object?> toMapWithoutId() {
    return {
      'name': name,
      'status': status,
      'photo': photo,
      'isOnline': isOnline ? 1 : 0,
    };
  }

  Friend.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        status = map['status'],
        photo = map['photo'],
        isOnline = map['isOnline'] == 1;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'photo': photo,
      'isOnline': isOnline ? 1 : 0,
    };
  }

  void toggleOnlineStatus() {
    isOnline = !isOnline;
    notifyListeners();
  }

  ImageProvider getFriendImage() {
    if (photo.startsWith('http')) {
      return NetworkImage(photo, scale: 1);
    } else {
      return const AssetImage('assets/faces/default.png');
    }
  }
}

class FriendsProvider with ChangeNotifier {
  List<Friend> _friends = [];
  Database? _database;

  List<Friend> get friends => _friends;

  set friends(List<Friend> friends) {
    _friends = friends;
    notifyListeners();
  }

  Future<void> fetchAndSetFriends() async {
    final fetchedFriends = await getFriends();
    _friends = fetchedFriends;
    notifyListeners();
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    const path = 'friends.db';

    return openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(
        '''
        CREATE TABLE friends(
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          name TEXT,
          status TEXT,
          photo TEXT,
          isOnline INTEGER
        )
        ''',
      );
    });
  }

  Future<void> checkAndInsertInitialFriends() async {
    final db = await database;
    final count = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM friends'));

    if (count == 0) {
      await _insertInitialFriends(); // Se estiver vazia, insere os amigos iniciais
    }
  }

  Future<void> addFriend(Friend friend) async {
    final db = await database;

    int id; // para armazenar o ID do novo registro inserido

    // Verifica se o ID do amigo é -1.
    if (friend.id == -1) {
      // Se sim, insira o registro sem especificar o ID.
      id = await db.insert(
        'friends',
        friend.toMapWithoutId(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } else {
      // Caso contrário, insira o registro com o ID especificado.
      id = await db.insert(
        'friends',
        friend.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    // Atualize a lista de amigos em memória com o novo amigo inserido
    Friend insertedFriend = Friend(
      id: id,
      name: friend.name,
      status: friend.status,
      photo: friend.photo,
      isOnline: friend.isOnline,
    );

    _friends.add(insertedFriend);
    notifyListeners(); // Notifica os ouvintes sobre a mudança
  }

  Future<void> deleteFriend(int id) async {
    // 1. Deletar o amigo do banco de dados SQLite
    final db = await database;
    await db.delete(
      'friends',
      where: 'id = ?',
      whereArgs: [id],
    );

    // 2. Deletar o amigo da lista em memória
    _friends.removeWhere((friend) => friend.id == id);

    // 3. Notificar ouvintes sobre a mudança
    notifyListeners();
  }

  Future<List<Friend>> getFriends() async {
    final db = await database;
    final maps = await db.query('friends');

    return List.generate(maps.length, (i) {
      return Friend(
        id: (maps[i]['id'] as int),
        name: maps[i]['name'] as String,
        status: maps[i]['status'] as String,
        photo: maps[i]['photo'] as String,
        isOnline: (maps[i]['isOnline'] as int) == 1,
      );
    });
  }

  Future<int> friendsCount() async {
    final db = await database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM friends'))!;
  }

  Future<void> _insertInitialFriends() async {
    final db = await database;

    // Lista de amigos para serem inseridos
    List<Friend> tmpFriends = [
      Friend(
          id: -1,
          name: 'Walter Alves',
          status: 'Squawk 7700',
          photo:
              'https://media-gru1-1.cdn.whatsapp.net/v/t61.24694-24/359545840_2481500805351035_6895775598026583637_n.jpg?ccb=11-4&oh=01_AdQHAgDFwtHFtKGBNvsTCUk5497SdZodBT-aZClOyG2FZw&oe=654FED6B&_nc_sid=e6ed6c&_nc_cat=106',
          isOnline: true),
      Friend(
          id: -1,
          name: 'Lilla Adhlyss',
          status: 'Wibly Wobly Timey Wimey',
          photo:
              'https://media-gru1-1.cdn.whatsapp.net/v/t61.24694-24/389809921_1086000919432912_4591175991150367984_n.jpg?ccb=11-4&oh=01_AdS7j0VMMCDtfsOJZSgaL71snLJ-yNT4XHMEUKcPQAvsfA&oe=654FBDFF&_nc_sid=e6ed6c&_nc_cat=105',
          isOnline: false),
      Friend(
          id: -1,
          name: 'Vini Lages',
          status: 'L',
          photo:
              'https://media-gru1-1.cdn.whatsapp.net/v/t61.24694-24/349423126_713511900534247_6867080459239269016_n.jpg?ccb=11-4&oh=01_AdTc6WEAm6yypXIP322DSHJuRy7g1ltQFid_c4FdPuMsag&oe=654FD676&_nc_sid=e6ed6c&_nc_cat=105',
          isOnline: true),
      Friend(
          id: -1,
          name: 'Sarah Kelly',
          status: '...',
          photo:
              'https://media-gru1-1.cdn.whatsapp.net/v/t61.24694-24/386206090_1054385005998658_885895072102375202_n.jpg?ccb=11-4&oh=01_AdTw94KHSwfwH_XJtUht9pu6usU8_LXYNVc8qtBAOnNILg&oe=654FEAAA&_nc_sid=e6ed6c&_nc_cat=102',
          isOnline: false),
      Friend(
          id: -1,
          name: 'Dogge',
          status: 'Snif',
          photo:
              'https://i.scdn.co/image/ab67616d0000b27329883b75034b015877e62408',
          isOnline: false),
      Friend(
          id: -1,
          name: 'Cecilia',
          status: '',
          photo:
              'https://media-gru1-1.cdn.whatsapp.net/v/t61.24694-24/364549870_1454391151795247_3406839739301010856_n.jpg?ccb=11-4&oh=01_AdQdobkv1X0Y9b0apc5hRRfEM3aNi8zsBg9w9zZbLKwSKQ&oe=654A6CD9&_nc_sid=000000&_nc_cat=105',
          isOnline: true),
      Friend(
          id: -1,
          name: 'Luan Matsumoto',
          status: 'Só chamadas urgentes',
          photo:
              'https://media-gru1-1.cdn.whatsapp.net/v/t61.24694-24/383768420_1454259188756834_908539885298978416_n.jpg?ccb=11-4&oh=01_AdQ7CpbV0aGnGLUWa2cyih-vQd464ArdI3CKO3gQvWPNfQ&oe=654FC05B&_nc_sid=e6ed6c&_nc_cat=109',
          isOnline: false),
      Friend(
          id: -1,
          name: 'Matt Canedo',
          status: 'Então, quem é o demônio? Aquele que não deixaria que ...',
          photo:
              'https://media-gru1-1.cdn.whatsapp.net/v/t61.24694-24/317043083_175517208417308_1486561940290512486_n.jpg?ccb=11-4&oh=01_AdQfi2Y118IYKGqkKgOl0biiYK4oTPWnvaBRz8zlerzg9g&oe=654A7D95&_nc_sid=000000&_nc_cat=101',
          isOnline: true),
      Friend(
          id: -1,
          name: 'ChatGPT',
          status: 'Sempre online para ajudar!',
          photo:
              'https://upload.wikimedia.org/wikipedia/commons/thumb/0/04/ChatGPT_logo.svg/1200px-ChatGPT_logo.svg.png',
          isOnline: true),
      Friend(
          id: -1,
          name: 'Tospericargerja',
          status: 'Brasil Tri campeao!',
          photo:
              'https://s2.glbimg.com/XrhDxWi0T1REUfNehtLjgRSOecg=/1200x630/filters:max_age(3600)/s04.video.glbimg.com/deo/vi/47/71/2057147',
          isOnline: false),
    ];

    for (var friend in tmpFriends) {
      await db.insert('friends', friend.toMapWithoutId(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  void toggleFriendOnlineStatus(int friendId) async {
    var index = _friends.indexWhere((friend) => friend.id == friendId);
    if (index != -1) {
      _friends[index].toggleOnlineStatus();

      // Atualiza no banco de dados
      await _updateOnlineStatusInDatabase(friendId, _friends[index].isOnline);

      notifyListeners();
    }
  }

  Future<void> _updateOnlineStatusInDatabase(
      int friendId, bool isOnline) async {
    await _database!.update(
      'friends',
      {'isOnline': isOnline ? 1 : 0},
      where: 'id = ?',
      whereArgs: [friendId],
    );
  }

  Future<Friend?> getFriendById(int id) async {
    final db = await database;
    final maps = await db.query(
      'friends',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Friend(
        id: maps[0]['id'] as int,
        name: maps[0]['name'] as String,
        status: maps[0]['status'] as String,
        photo: maps[0]['photo'] as String,
        isOnline: (maps[0]['isOnline'] as int) == 1,
      );
    }
    return null; // Retorna nulo se o amigo não for encontrado.
  }
}
