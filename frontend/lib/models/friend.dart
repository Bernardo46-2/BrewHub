import 'dart:math';

import 'package:flutter/foundation.dart';

class Friend with ChangeNotifier {
  final String name;
  final String status;
  final String photo;
  bool isOnline;

  Friend({
    required this.name,
    required this.status,
    required this.photo,
    this.isOnline = false,
  });

  void toggleOnlineStatus() {
    isOnline = !isOnline;
    notifyListeners();
  }
}

class FriendsProvider with ChangeNotifier {
  List<Friend> _friends = [tmpFriends[0], tmpFriends[1]];
  List<Friend> get friends => _friends;

  set friends(List<Friend> friendsList) {
    _friends = friendsList;
    notifyListeners();
  }

  int _nextFriendIndex = 2;
  int get nextFriendIndex => _nextFriendIndex;
  void addFriend() {
    if (friends.length < _nextFriendIndex) {
      _nextFriendIndex = 2;
    }
    if (_nextFriendIndex < tmpFriends.length) {
      final nextFriend = tmpFriends[_nextFriendIndex];
      _friends.add(nextFriend);
      _nextFriendIndex++;
      notifyListeners();
    } else {
      final random = Random();
      final randomIndex =
          random.nextInt(_friends.length);
      final randomFriend = _friends[randomIndex];

      randomFriend.toggleOnlineStatus();

      notifyListeners();
    }
  }

  void updateFriendStatus(String name, bool status) {
    _friends.firstWhere((f) => f.name == name).isOnline = status;
    notifyListeners();
  }

  void reset() {
    _friends = [tmpFriends[0], tmpFriends[1]];
    _nextFriendIndex = 2;
    notifyListeners();
  }
}

List<Friend> loadUserFriends() {
  return [tmpFriends[0], tmpFriends[1]];
}

List<Friend> tmpFriends = [
  Friend(
      name: 'AlexM_92',
      status: 'Café na mão, fone no ouvido. Let\'s code!',
      photo: 'assets/faces/alex.png',
      isOnline: true),
  Friend(
      name: 'ClaraFields',
      status: 'No modo "Não Perturbe". Deadline chegando!',
      photo: 'assets/faces/clara.png',
      isOnline: false),
  Friend(
      name: 'BrianTech',
      status: 'Deep dive em documentação. Send help!',
      photo: 'assets/faces/brian.png',
      isOnline: true),
  Friend(
      name: 'SarahLopez',
      status: 'Almoço prolongado. De volta às 15h.',
      photo: 'assets/faces/sarah.png',
      isOnline: false),
  Friend(
      name: 'MichaelT',
      status: 'Early bird gets the worm. Ou o código, no meu caso.',
      photo: 'assets/faces/michael.png',
      isOnline: false),
  Friend(
      name: 'JasmineF',
      status: 'Entre uma reunião e outra. Disponível em 10 min.',
      photo: 'assets/faces/jasmine.png',
      isOnline: true),
  Friend(
      name: 'EdwardS',
      status: 'Brainstorming com o time. Vamos inovar!',
      photo: 'assets/faces/edward.png',
      isOnline: false),
  Friend(
      name: 'NinaParker',
      status: 'Dia produtivo! Offline até amanhã.',
      photo: 'assets/faces/nina.png',
      isOnline: false),
  Friend(
      name: 'ChatGPT',
      status: 'Sempre online para ajudar!',
      photo: 'assets/faces/gpt.png',
      isOnline: true),
  Friend(
      name: 'Tospericargerja',
      status: 'Brasil Tri campeao!',
      photo: 'assets/faces/Tospericargerja.png',
      isOnline: false),
];
