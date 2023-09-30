import 'package:brewhub/chat/chat.dart';
import 'package:flutter/material.dart';
import 'package:brewhub/style.dart';
import 'package:brewhub/models/friend.dart';
import 'package:provider/provider.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPage();
}

class _FriendsPage extends State<FriendsPage> {
  List<Friend> friends = []; // Lista de amigos

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Acesse o FriendsProvider para obter a lista de amigos
    FriendsProvider friendsProvider = Provider.of<FriendsProvider>(context);

    // Obtenha a lista de amigos do FriendsProvider
    List<Friend> friends = friendsProvider.friends;

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
              color: primary4_75,
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: const Icon(Icons.person_add, color: Colors.white),
              onPressed: () {
                // Obtém uma referência ao FriendsProvider
                FriendsProvider friendsProvider =
                    Provider.of<FriendsProvider>(context, listen: false);

                // Chama a função para adicionar um amigo
                friendsProvider.addFriend();
              },
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          backgroundHome(context),
          FriendsList(friends: friends),
        ],
      ),
    );
  }
}

class FriendTile extends StatelessWidget {
  final Friend friend;
  final bool isLast;

  const FriendTile({super.key, required this.friend, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(friend.photo),
                radius: 23,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        friend.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        friend.status,
                        style: const TextStyle(color: white75),
                        overflow: TextOverflow.clip,
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  const SizedBox(width: 10),
                  Material(
                    color: dark2_75,
                    shape: const CircleBorder(),
                    child: InkWell(
                      highlightColor: primary4,
                      splashColor: primary4,
                      customBorder: const CircleBorder(),
                      onTap: () {
                        // TODO: Função para fazer ligação
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.call, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10), // Espaço entre os botões
                  Material(
                    color: dark2_75,
                    shape: const CircleBorder(),
                    child: InkWell(
                      highlightColor: primary4,
                      splashColor: primary4,
                      customBorder: const CircleBorder(),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(friend: friend),
                          ),
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.chat, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        if (!isLast)
          Padding(
            padding: const EdgeInsets.only(left: 65.0),
            child: Divider(color: Colors.white.withOpacity(0.2)),
          ),
      ],
    );
  }
}

class FriendsList extends StatelessWidget {
  final List<Friend> friends;

  const FriendsList({super.key, required this.friends});

  @override
  Widget build(BuildContext context) {
    List<Friend> onlineFriends = friends.where((f) => f.isOnline).toList();
    List<Friend> offlineFriends = friends.where((f) => !f.isOnline).toList();

    return ListView(
      children: [
        ListTile(
          title: Text(
            'Online — ${onlineFriends.length}',
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
            'Offline — ${offlineFriends.length}',
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
