import 'package:flutter/material.dart';
import 'package:brewhub/style.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPage();
}

class _FriendsPage extends State<FriendsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: dark3,
        automaticallyImplyLeading: false,
        title: const Text("Amigos"),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
            width: 40,
            decoration: BoxDecoration(
              color: primary3,
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: const Icon(Icons.person_add, color: Colors.white),
              onPressed: () {
                // TODO: Código para adicionar alguém
              },
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          backgroundHome(context), // Sua imagem de fundo
          FriendsList(),
        ],
      ),
    );
  }
}

class Friend {
  final String name;
  final String description;
  final String imageUrl;
  final bool isOnline;

  Friend({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.isOnline,
  });
}

class FriendTile extends StatelessWidget {
  final Friend friend;
  final bool isLast;

  const FriendTile({Key? key, required this.friend, this.isLast = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage(
              friend.imageUrl,
            ),
          ),
          title: Text(
            friend.name,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            friend.description,
            style: const TextStyle(color: white75, fontSize: 12),
          ),
          trailing: Wrap(
            spacing: 5.0,  // Espaço entre os ícones
            children: [
              SizedBox(
                width: 30.0,
                child: IconButton(
                  padding: const EdgeInsets.all(4.0),  // Reduz o padding do botão
                  icon: const Icon(Icons.call, color: white85),
                  onPressed: () {
                    // Código para ligar
                  },
                ),
              ),
              SizedBox(
                width: 30.0,
                child: IconButton(
                  padding: const EdgeInsets.all(4.0),  // Reduz o padding do botão
                  icon: const Icon(Icons.chat, color: white85),
                  onPressed: () {
                    // Código para abrir chat
                  },
                ),
              ),
            ],
          ),
        ),
        if (!isLast) 
          Divider(color: Colors.white.withOpacity(0.2), thickness: 0.5),
      ],
    );
  }
}

class FriendsList extends StatelessWidget {
  final List<Friend> friends = [
    Friend(
        name: 'AlexM_92',
        description: 'Café na mão, fone no ouvido. Let\'s code!',
        imageUrl: 'assets/faces/alex.png',
        isOnline: true),
    Friend(
        name: 'ClaraFields',
        description: 'No modo "Não Perturbe". Deadline chegando!',
        imageUrl: 'assets/faces/clara.png',
        isOnline: false),
    Friend(
        name: 'BrianTech',
        description: 'Deep dive em documentação. Send help!',
        imageUrl: 'assets/faces/brian.png',
        isOnline: true),
    Friend(
        name: 'SarahLopez',
        description: 'Almoço prolongado. De volta às 15h.',
        imageUrl: 'assets/faces/sarah.png',
        isOnline: false),
    Friend(
        name: 'MichaelT',
        description: 'Early bird gets the worm. Ou o código, no meu caso.',
        imageUrl: 'assets/faces/michael.png',
        isOnline: true),
    Friend(
        name: 'JasmineF',
        description: 'Entre uma reunião e outra. Disponível em 10 min.',
        imageUrl: 'assets/faces/jasmine.png',
        isOnline: true),
    Friend(
        name: 'EdwardS',
        description: 'Brainstorming com o time. Vamos inovar!',
        imageUrl: 'assets/faces/edward.png',
        isOnline: false),
    Friend(
        name: 'NinaParker',
        description: 'Dia produtivo! Offline até amanhã.',
        imageUrl: 'assets/faces/nina.png',
        isOnline: false),
    Friend(
        name: 'ChatGPT',
        description: 'Sempre online para ajudar!',
        imageUrl: 'assets/faces/gpt.png',
        isOnline: true),
    Friend(
        name: 'Tospericargerja',
        description: 'Brasil Tri campeao!',
        imageUrl: 'assets/faces/Tospericargerja.png',
        isOnline: false),
  ];

  int countOnline() {
    return friends.where((friend) => friend.isOnline).length;
  }

  int countOffline() {
    return friends.where((friend) => !friend.isOnline).length;
  }

  FriendsList({super.key});

  @override
  Widget build(BuildContext context) {
    List<Friend> onlineFriends = friends.where((f) => f.isOnline).toList();
    List<Friend> offlineFriends = friends.where((f) => !f.isOnline).toList();

    return ListView(
      children: [
        ListTile(
          title: Text(
            'Online — ${countOnline()}',
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        ...onlineFriends
            .map((friend) => FriendTile(
                friend: friend, isLast: friend == onlineFriends.last))
            .toList(),
        ListTile(
          title: Text(
            'Offline — ${countOffline()}',
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        ...offlineFriends
            .map((friend) => FriendTile(
                friend: friend, isLast: friend == offlineFriends.last))
            .toList(),
      ],
    );
  }
}
