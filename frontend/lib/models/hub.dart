import 'dart:math';

import 'package:flutter/material.dart';
import 'package:brewhub/models/icon_utility.dart';
import 'package:sqflite/sqflite.dart';

class Hub {
  final int id;
  final String name;
  final String imageUrl;
  final int onlineCount;
  final int totalCount;
  final IconData icon;

  Hub({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.onlineCount,
    required this.totalCount,
    required this.icon,
  });

  static Hub fromMap(Map<String, dynamic> map) {
    return Hub(
      id: map['id'],
      name: map['name'],
      imageUrl: map['imageUrl'],
      onlineCount: map['onlineCount'],
      totalCount: map['totalCount'],
      icon: IconUtility.getIconDataFromString(map['iconText']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'onlineCount': onlineCount,
      'totalCount': totalCount,
      'iconText': IconUtility.getStringFromIconData(icon),
    };
  }

  Map<String, Object?> toMapWithoutId() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'onlineCount': onlineCount,
      'totalCount': totalCount,
      'iconText': IconUtility.getStringFromIconData(icon),
    };
  }

  ImageProvider getHubImage() {
    if (imageUrl.startsWith('http')) {
      return NetworkImage(imageUrl, scale: 1);
    } else if (imageUrl.startsWith('assets')) {
      return AssetImage(imageUrl);
    } else {
      return const AssetImage('assets/faces/default.png');
    }
  }
}

class HubsProvider with ChangeNotifier {
  List<Hub> _hubs = [];
  Database? _database;

  List<Hub> get hubs => _hubs;

  set hubs(List<Hub> hubs) {
    _hubs = hubs;
    notifyListeners();
  }

  Future<void> fetchAndSetHubs() async {
    final fetchedHubs = await getHubs();
    _hubs = fetchedHubs;
    notifyListeners();
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    const path = 'hubs.db';
    return openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(
        '''
        CREATE TABLE hubs(
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          name TEXT,
          imageUrl TEXT, 
          onlineCount INTEGER, 
          totalCount INTEGER, 
          iconText TEXT
        )
        ''',
      );
    });
  }

  Future<void> checkAndInsertInitialHubs() async {
    final db = await database;
    final count =
        Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM hubs'));

    if (count == 0) {
      await _insertInitialHubs(); // Se estiver vazia, insere os hubs iniciais
    }
  }

  Future<void> addHub(Hub hub) async {
    final db = await database;

    int id; // para armazenar o ID do novo registro inserido

    // Verifica se o ID do hub é -1.
    if (hub.id == -1) {
      // Se sim, insira o registro sem especificar o ID.
      id = await db.insert(
        'hubs',
        hub.toMapWithoutId(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } else {
      // Caso contrário, insira o registro com o ID especificado.
      id = await db.insert(
        'hubs',
        hub.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    // Atualize a lista de hubs em memória com o novo hub inserido
    Hub insertedHub = Hub(
      id: id,
      name: hub.name,
      imageUrl: hub.imageUrl,
      onlineCount: hub.onlineCount,
      totalCount: hub.totalCount,
      icon: hub.icon,
    );

    _hubs.add(insertedHub);
    notifyListeners(); // Notifica os ouvintes sobre a mudança
  }

  Future<void> deleteHub(int id) async {
    // 1. Deletar o hub do banco de dados SQLite
    final db = await database;
    await db.delete(
      'hubs',
      where: 'id = ?',
      whereArgs: [id],
    );

    // 2. Deletar o hub da lista em memória
    _hubs.removeWhere((hub) => hub.id == id);

    // 3. Notificar ouvintes sobre a mudança
    notifyListeners();
  }

  Future<List<Hub>> getHubs() async {
    final db = await database;
    final maps = await db.query('hubs');

    return List.generate(maps.length, (i) {
      return Hub(
        id: maps[i]['id'] as int,
        name: maps[i]['name'] as String,
        imageUrl: maps[i]['imageUrl'] as String,
        onlineCount: maps[i]['onlineCount'] as int,
        totalCount: maps[i]['totalCount'] as int,
        icon: IconUtility.getIconDataFromString(maps[i]['iconText'] as String),
      );
    });
  }

  Future<void> _insertInitialHubs() async {
    final db = await database;

    // Lista de hubs para serem inseridos
    List<Hub> tmpHubs = [
      Hub(
        id: -1,
        name: 'Plannejy',
        imageUrl: 'assets/hub/default.png',
        onlineCount: Random().nextInt(30),
        totalCount: 30 + Random().nextInt(20),
        icon: Icons.calendar_month,
      ),
      Hub(
        id: -1,
        name: 'Puc - CC',
        imageUrl: 'assets/hub/hub1.png',
        onlineCount: Random().nextInt(30),
        totalCount: 30 + Random().nextInt(20),
        icon: Icons.school,
      ),
      Hub(
        id: -1,
        name: 'Avião Brutal',
        imageUrl: 'assets/hub/hub2.png',
        onlineCount: Random().nextInt(30),
        totalCount: 30 + Random().nextInt(20),
        icon: Icons.flight,
      ),
    ];

    for (var hub in tmpHubs) {
      await db.insert('hubs', hub.toMapWithoutId(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }
}
