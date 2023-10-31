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
              'https://scontent.fplu33-1.fna.fbcdn.net/v/t39.30808-6/365896111_988765365499763_1678912154615413266_n.jpg?_nc_cat=105&ccb=1-7&_nc_sid=5f2048&_nc_eui2=AeFaJDm1S4JQ118d4xPKW9jNY4DAlW5UNw9jgMCVblQ3DztOZ9FtiAJD5CrMPRdPfCdnVN53pu-70LQIKb_Z1FA7&_nc_ohc=2I8obI06bhsAX8e2O3B&_nc_oc=AQk9b8eJ0CJ28JH3bsX7dszwGTyhhhJ7ssQNKaBrVVZ-8tw3HPw4uOBSlUB_R4eOs5Y&_nc_ht=scontent.fplu33-1.fna&oh=00_AfA4odhF85H6elr1m8K_lHHJs8Qrwgcb3n2qeuc0_AczmA&oe=65428BEF',
          isOnline: true),
      Friend(
          id: -1,
          name: 'Lilla Adhlyss',
          status: 'Wibly Wobly Timey Wimey',
          photo:
              'https://scontent.fplu33-1.fna.fbcdn.net/v/t39.30808-6/324885531_679745897026970_3004840708359347446_n.jpg?_nc_cat=102&ccb=1-7&_nc_sid=5f2048&_nc_eui2=AeGanqCTRR_JTabXfhL7Bv3267HkntxxqwrrseSe3HGrCggjASPXWi-hhX6QXf3F-rFmHT4br6waLLtTKQAOAcIn&_nc_ohc=HSxwolu1tikAX8nOx1R&_nc_ht=scontent.fplu33-1.fna&oh=00_AfAaeFzXCUJEByqW_YqsEh7b6LWRY-us4NB9zxQHy6uVug&oe=65432FB7',
          isOnline: false),
      Friend(
          id: -1,
          name: 'Fernando Augusto',
          status: 'L',
          photo:
              'https://scontent.fplu33-1.fna.fbcdn.net/v/t39.30808-6/328347901_1484211388773633_1033593142037780645_n.jpg?_nc_cat=107&ccb=1-7&_nc_sid=5f2048&_nc_eui2=AeG2AGKrhEBblxFyUmMg12RF57y48urm_IrnvLjy6ub8isLsvRajyviPn0xVhlLIqqN_TUw6nElLmEv6lJXPBMje&_nc_ohc=mbyKi8MVS3AAX9-9qgz&_nc_ht=scontent.fplu33-1.fna&oh=00_AfBwmounLb_BDsKVM1o1UDe1lco5j1vipctTzNyz-tet9w&oe=6542055B',
          isOnline: true),
      Friend(
          id: -1,
          name: 'Sarah Kelly',
          status: '...',
          photo:
              'https://scontent.fplu33-1.fna.fbcdn.net/v/t39.30808-6/348478444_618747633609535_3568139516769812170_n.jpg?_nc_cat=101&ccb=1-7&_nc_sid=5f2048&_nc_eui2=AeHsn57lmHRIJ84eYtMTaocorf6etLBZh4Ot_p60sFmHg9h4OHA5jDwL0fB-M9vUbaQoIqmAKvG9cXRqaqRcvp4O&_nc_ohc=_52qBAfbZ6kAX_yHQcK&_nc_ht=scontent.fplu33-1.fna&oh=00_AfA4Zidjn0Ysuu3QMGY7GJkenwcxjOTTSO8mM5_zD44Zfg&oe=654333CA',
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
              'https://scontent.fplu33-1.fna.fbcdn.net/v/t39.30808-6/353798459_214169444826346_8759020322014440683_n.jpg?_nc_cat=104&ccb=1-7&_nc_sid=5f2048&_nc_eui2=AeG0Fg-mtVjJe5aFNmiZsqftAhEmFRqVMXgCESYVGpUxeGCtr1ATjtuTDYd-KPdV44BQIzqFbOJHjqDLJi0G7mpS&_nc_ohc=4W2DFJu_THMAX82siAT&_nc_ht=scontent.fplu33-1.fna&oh=00_AfApRz2HC-cUVkHRPtq0SYZAGxoa8hn4QySci1ZbfWuFqg&oe=6542BE24',
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
