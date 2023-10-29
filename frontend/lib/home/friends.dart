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
  @override
  void initState() {
    super.initState();
    Provider.of<FriendsProvider>(context, listen: false).fetchAndSetFriends();
  }

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
              color: primary4_75,
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: const Icon(Icons.person_add, color: Colors.white),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => const AddFriendModal(),
                );
              },
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          backgroundHome(context),
          Consumer<FriendsProvider>(
            builder: (ctx, friendsProvider, _) =>
                FriendsList(friends: friendsProvider.friends),
          ),
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
    return InkWell(
      onLongPress: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: dark2,
              title: const Text(
                "Deletar usuário",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              content: const Text(
                "Deseja realmente deletar este usuário?",
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
                      final friendsProvider =
                          Provider.of<FriendsProvider>(context, listen: false);

                      // Chame o método de deleção e, depois que ele terminar, mostre o SnackBar.
                      friendsProvider.deleteFriend(friend.id).then((_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Amigo excluído com sucesso!'),
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
        Provider.of<FriendsProvider>(context, listen: false)
            .toggleFriendOnlineStatus(friend.id);
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
                  CircleAvatar(
                    backgroundImage: friend.getFriendImage(),
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

class FriendsList extends StatelessWidget {
  final List<Friend> friends;

  const FriendsList({super.key, required this.friends});

  @override
  Widget build(BuildContext context) {
    List<Friend> onlineFriends = friends.where((f) => f.isOnline).toList();
    List<Friend> offlineFriends = friends.where((f) => !f.isOnline).toList();

    return ListView.builder(
      itemCount: 2 + onlineFriends.length + offlineFriends.length,
      itemBuilder: (ctx, index) {
        if (index == 0) {
          return ListTile(
            title: Text(
              'Online — ${onlineFriends.length}',
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          );
        } else if (index <= onlineFriends.length) {
          return FriendTile(
              friend: onlineFriends[index - 1],
              isLast: onlineFriends[index - 1] == onlineFriends.last);
        } else if (index == onlineFriends.length + 1) {
          return ListTile(
            title: Text(
              'Offline — ${offlineFriends.length}',
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          );
        } else {
          return FriendTile(
              friend: offlineFriends[index - onlineFriends.length - 2],
              isLast: offlineFriends[index - onlineFriends.length - 2] ==
                  offlineFriends.last);
        }
      },
    );
  }
}

class AddFriendModal extends StatefulWidget {
  const AddFriendModal({super.key});

  @override
  State<AddFriendModal> createState() => _AddFriendModalState();
}

class _AddFriendModalState extends State<AddFriendModal> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: dark3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 3, bottom: 18),
              child: Text(
                'Adicionar Amigo',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: white85,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Para o campo "Nome de Usuário":
            TextField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.alternate_email,
                    color: Colors.white), // Ícone '@'
                labelText: 'Nome de Usuário',
                labelStyle: const TextStyle(color: white75),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                fillColor: dark2_75,
              ),
            ),
            const SizedBox(height: 10),
            // Para o campo "Código de Usuário":
            TextField(
              controller: _idController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                prefixIcon:
                    const Icon(Icons.tag, color: Colors.white), // Ícone '#'
                labelText: 'Código de Usuário',
                labelStyle: const TextStyle(color: white75),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                fillColor: dark2_75,
              ),
              keyboardType: TextInputType.number,
            ),
            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              )
            else
              const SizedBox.shrink(), // Não mostre nada se não houver erro
            const SizedBox(height: 10),
            SizedBox(
              width: double
                  .infinity, // Isso faz o Container ocupar toda a largura disponível
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('Adicionar'),
                onPressed: () {
                  if (_nameController.text.isNotEmpty &&
                      _idController.text.isNotEmpty) {
                    // Converta o código de usuário para um número inteiro
                    final userId = int.tryParse(_idController.text);
                    if (userId != null) {
                      // Adicione o contato ao banco de dados e atualize a lista
                      final newFriend = Friend(
                        id: userId,
                        name: _nameController.text,
                        status: "...", // Status padrão
                        photo: 'assets/faces/default.png', // Imagem padrão
                        isOnline: false,
                      );
                      Provider.of<FriendsProvider>(context, listen: false)
                          .addFriend(newFriend);
                      // Limpe a mensagem de erro (se houver)
                      setState(() {
                        errorMessage = null;
                      });
                      // Fecha o modal
                      Navigator.of(context).pop();
                    } else {
                      // Atualize a mensagem de erro
                      setState(() {
                        errorMessage = 'Código de usuário inválido!';
                      });
                    }
                  } else {
                    setState(() {
                      errorMessage = 'Ambos os campos são obrigatórios!';
                    });
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
