// ignore_for_file: library_private_types_in_public_api

import 'dart:async';
import 'dart:math';

import 'package:brewhub/chat/input_bar.dart';
import 'package:brewhub/models/friend.dart';
import 'package:brewhub/models/message.dart'; // Supondo que você tenha este arquivo
import 'package:flutter/material.dart';
import 'package:brewhub/style.dart';

class ChatScreen extends StatefulWidget {
  final Friend friend;

  const ChatScreen({Key? key, required this.friend}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Message> _messages = [];
  final StreamController<List<Message>> _messagesStreamController =
      StreamController<List<Message>>();
  final ScrollController _listViewController = ScrollController();
  final ChatSimulator chatSimulator = ChatSimulator();
  StreamSubscription? _messageSubscription;

  Future<void> _generateRandomMessages() async {
    final random = Random(DateTime.now().millisecondsSinceEpoch);

    _messageSubscription = Stream.periodic(
      Duration(seconds: (random.nextInt(12) + 3)),
    ).listen((_) {
      final randomMessage = Message(
        senderId: '456',
        receiverId: '123',
        content: chatSimulator.randomMessage,
        timestamp: DateTime.now(),
        status: MessageStatus.notSent,
      );

      if (!_messagesStreamController.isClosed) {
        _messages.insert(0, randomMessage);
        _messagesStreamController.add(List.from(_messages));
      }
    });
  }

  @override
  void dispose() {
    _messageSubscription?.cancel();
    _messagesStreamController.close();
    _listViewController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _generateRandomMessages().then((_) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: dark3,
        automaticallyImplyLeading: false,
        titleSpacing: 0.0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: widget.friend.getFriendImage(),
              radius: 23,
            ),
            const SizedBox(width: 10),
            Text(widget.friend.name,
                style: const TextStyle(color: Colors.white)),
          ],
        ),
        leading: const BackButton(color: Colors.white),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
            width: 40,
            decoration: BoxDecoration(
              color: primary4_75,
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: const Icon(Icons.call, color: Colors.white),
              onPressed: () {
                // TODO: Função para iniciar uma chamada
              },
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          backgroundHome(context),
          Column(
            children: [
              Expanded(
                child: StreamBuilder<List<Message>>(
                  stream: _messagesStreamController.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(
                          child: Text('Erro ao carregar mensagens.'));
                    } else if (snapshot.hasData) {
                      List<Message> messages = snapshot.data!;
                      return ListView.builder(
                        controller: _listViewController,
                        padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                        itemCount: messages.length,
                        reverse: true,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          bool isMe = message.senderId == '123';
                          return MessageBubble(message: message, isMe: isMe);
                        },
                      );
                    }
                    return const Center(
                      child: Text(
                        'Nenhuma mensagem disponível.',
                        style: TextStyle(color: white50),
                      ),
                    );
                  },
                ),
              ),
              ChatInputBar(
                onSendMessage: (messageContent) {
                  final newMessage = Message(
                    senderId: '123',
                    receiverId: '456',
                    content: messageContent,
                    timestamp: DateTime.now(),
                    status: MessageStatus.notSent,
                  );
                  setState(() {
                    _messages.insert(0,
                        newMessage); // Adiciona a mensagem ao início da lista
                    _messagesStreamController.add(List.from(
                        _messages)); // Adiciona a lista atualizada ao stream
                  });
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final Message message;
  final bool isMe;

  const MessageBubble({required this.message, required this.isMe, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          margin: EdgeInsets.only(
            top: 5,
            bottom: 5,
            left: isMe
                ? 50
                : 10, // Se for uma mensagem sua, aumente a margem esquerda
            right: isMe
                ? 10
                : 50, // Se for uma mensagem sua, diminua a margem direita
          ),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.80,
          ),
          decoration: BoxDecoration(
            color: isMe ? primary2_75 : dark2,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            message.content,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w400, fontSize: 16),
          ),
        ),
      ],
    );
  }
}
