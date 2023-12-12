import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class Friend with ChangeNotifier {
  final int id;
  final String name;
  final String status;
  final String photo;
  final String shard;
  bool isOnline;

  Friend({
    required this.id,
    required this.name,
    required this.status,
    required this.photo,
    required this.shard,
    required this.isOnline,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'photo': photo,
      'shard': shard,
      'isOnline': isOnline ? 1 : 0
    };
  }

  Map<String, Object?> toMapWithoutId() {
    return {
      'name': name,
      'status': status,
      'photo': photo,
      'shard': shard,
      'isOnline': isOnline ? 1 : 0,
    };
  }

  Friend.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        status = map['status'],
        photo = map['photo'],
        shard = map['shard'],
        isOnline = map['isOnline'] == 1;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'photo': photo,
      'shard': shard,
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
      return const AssetImage('assets/doggo.jpg');
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
          shard TEXT,
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

  Future<bool> addFriendFromFirestore(String name, String shard) async {
    // Buscar no Firestore
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('nick', isEqualTo: name)
        .where('shard', isEqualTo: shard)
        .get();

    // Verificar se encontrou o usuário
    if (querySnapshot.docs.isNotEmpty) {
      var doc = querySnapshot.docs.first;
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      Friend friend = Friend(
        id: -1,
        name: data['nick'] as String,
        status: data['status'] as String,
        photo: data['photo'] as String,
        shard: data['shard'] as String,
        isOnline: true,
      );
      print(friend);
      // Adicionar ao SQLite
      await addFriend(friend);
      return true;
    } else {
      print("deu ruim foi demais");
      return false;
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
      shard: friend.shard,
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
        shard: maps[i]['shard'] as String,
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
            'https://engineering.unl.edu/images/staff/Kayla-Person.jpg',
        shard: '123',
        isOnline: true,
      ),
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
        shard: maps[0]['shard'] as String,
        isOnline: (maps[0]['isOnline'] as int) == 1,
      );
    }
    return null; // Retorna nulo se o amigo não for encontrado.
  }
}
