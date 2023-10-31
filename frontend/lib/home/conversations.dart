import 'package:brewhub/chat/chat.dart';
import 'package:brewhub/models/friend.dart';
import 'package:brewhub/models/message.dart';
import 'package:flutter/material.dart';
import 'package:brewhub/style.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ConversationsPage extends StatefulWidget {
  const ConversationsPage({super.key});

  @override
  State<ConversationsPage> createState() => _ConversationsPage();
}

class _ConversationsPage extends State<ConversationsPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Inicialize o FriendsProvider e busque os amigos.
    final friendsProvider =
        Provider.of<FriendsProvider>(context, listen: false);
    friendsProvider.fetchAndSetFriends().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: dark3,
        automaticallyImplyLeading: false,
        title: const Text("Conversas"),
      ),
      body: Stack(
        children: [
          backgroundHome(context),
          if (_isLoading)
            const CircularProgressIndicator()
          else
            Consumer<ConversationProvider>(
              builder: (ctx, conversationProvider, _) {
                return Consumer<FriendsProvider>(
                  builder: (ctx, friendsProvider, _) {
                    final conversationsFuture = conversationProvider
                        .getConversations(); // Note that this returns a Future
                    final friends = friendsProvider.friends;

                    return FutureBuilder<List<Conversation>>(
                      future: conversationsFuture,
                      builder: (ctx, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Ocorreu um erro: ${snapshot.error}');
                        } else {
                          final conversations = snapshot.data;
                          if (conversations == null) {
                            // Handle the case when conversations are not available yet
                            return const CircularProgressIndicator();
                          }
                          return ConversationsList(
                            conversations: conversations,
                            friends: friends,
                          );
                        }
                      },
                    );
                  },
                );
              },
            ),
        ],
      ),
    );
  }
}

class ConversationTile extends StatelessWidget {
  final Conversation conversation;
  final Friend friend;
  final bool isLast;

  const ConversationTile({
    super.key,
    required this.conversation,
    required this.friend,
    required this.isLast,
  });

  String _messageTime(DateTime? messageTime) {
    if (messageTime == null) {
      return '';
    }

    DateTime now = DateTime.now();
    if (messageTime.year == now.year &&
        messageTime.month == now.month &&
        messageTime.day == now.day) {
      return DateFormat('HH:mm')
          .format(messageTime); // Se for o mesmo dia, apenas a hora.
    } else {
      return DateFormat('dd/MM')
          .format(messageTime); // Caso contrário, apenas a data.
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: dark2,
              title: const Text(
                "Deletar conversa",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              content: const Text(
                "Deseja realmente deletar este conversa?",
                style: TextStyle(color: white75),
              ),
              actions: [
                TextButton(
                  child:
                      const Text("Cancelar", style: TextStyle(color: primary4)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: TextButton(
                    child: const Text("Deletar",
                        style: TextStyle(color: Colors.red)),
                    onPressed: () {
                      final conversationProvider =
                          Provider.of<ConversationProvider>(context,
                              listen: false);

                      // Chame o método de deleção e, depois que ele terminar, mostre o SnackBar.
                      conversationProvider
                          .deleteConversation(friend.id)
                          .then((_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Conversa excluida com sucesso!'),
                          ),
                        );
                        Navigator.of(context).pop();
                      }).catchError((error) {
                        // Manipule o erro aqui, se necessário.
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Contato não excluído: Erro 666'),
                          ),
                        );
                        Navigator.of(context).pop();
                      });
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              friend: friend,
              isGroupChat: false,
            ),
          ),
        );
      },
      highlightColor: primary3,
      splashColor: primary3,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Container(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FutureBuilder<Friend?>(
                    future: Provider.of<FriendsProvider>(context, listen: false)
                        .getFriendById(conversation.friendId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return const CircleAvatar(
                          radius: 25,
                          child: Icon(Icons.error),
                        );
                      } else if (snapshot.hasData && snapshot.data != null) {
                        return CircleAvatar(
                          backgroundImage: snapshot.data!.getFriendImage(),
                          radius: 25,
                        );
                      } else {
                        return const CircleAvatar(
                          radius: 25,
                          child: Text('N/A'),
                        );
                      }
                    },
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
                            conversation.lastMessageText ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: white75,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Text(
                      _messageTime(conversation.lastMessageTimestamp),
                      style: const TextStyle(
                        color: white75,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (!isLast)
            Padding(
              padding: const EdgeInsets.only(left: 65.0),
              child: Divider(
                color: Colors.white.withOpacity(0.2),
                height: 1.0,
              ),
            ),
        ],
      ),
    );
  }
}

class ConversationsList extends StatelessWidget {
  final List<Conversation> conversations;
  final List<Friend> friends;

  const ConversationsList(
      {super.key, required this.conversations, required this.friends});

  @override
  Widget build(BuildContext context) {
    // Cria um mapa de amigos com seus IDs como chaves para acesso rápido
    Map<int, Friend> friendsMap = {
      for (var friend in friends) friend.id: friend
    };

    return ListView.builder(
      itemCount: conversations.length,
      itemBuilder: (ctx, index) {
        var conversation = conversations[index];
        var friend = friendsMap[conversation.friendId];

        return ConversationTile(
          conversation: conversation,
          isLast: conversation == conversations.last,
          friend: friend!,
        );
      },
    );
  }
}
