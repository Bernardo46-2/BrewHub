// ignore_for_file: library_private_types_in_public_api

import 'dart:async';
import 'dart:math';
import 'package:brewhub/chat/input_bar.dart';
import 'package:brewhub/models/friend.dart';
import 'package:brewhub/models/message.dart';
import 'package:brewhub/style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final Friend friend;
  final bool isGroupChat;

  const ChatScreen({
    Key? key,
    required this.friend,
    required this.isGroupChat,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Message> _messages = [];
  final StreamController<List<Message>> _messagesStreamController =
      StreamController<List<Message>>();
  final ScrollController _listViewController = ScrollController();
  final ConversationProvider _conversationProvider = ConversationProvider();
  final ChatSimulator chatSimulator = ChatSimulator();
  StreamSubscription? _messageSubscription;
  late final MessageStreamer _messageStreamer;

  @override
  void initState() {
    super.initState();
    _initializeConversation();
  }

  Future<void> _initializeConversation() async {
    await ensureConversationExists(widget.friend.id);

    _messageStreamer = MessageStreamer(_conversationProvider);
    _fetchMessages();
    _messageStreamer.startSimulation(widget.friend.id);
    _messageStreamer.messageStream.listen((message) {
      if (!_messagesStreamController.isClosed) {
        _messages.insert(0, message);
        _messagesStreamController.add(List.from(_messages));
      }
    });
  }

  Future<void> ensureConversationExists(int friendId) async {
    // Verifica se a conversa já existe
    final conversation = await _conversationProvider.getConversation(friendId);

    // Conversa não existe, cria uma nova
    if (conversation == null) {
      await _conversationProvider.createConversation(friendId);
    }
  }

  Future<void> _fetchMessages() async {
    _messages = await _conversationProvider.getMessages(widget.friend.id);
    _messagesStreamController.add(_messages);
  }

  Future<void> _sendMessage(String messageContent) async {
    final newMessage = Message(
      id: null,
      friendId: widget.friend.id,
      senderId: 0,
      content: messageContent,
      timestamp: DateTime.now(),
      status: MessageStatus.notSent,
      type: MessageType.text,
    );

    Message msg = await _conversationProvider.addMessage(newMessage);

    // Atualiza a lista de mensagens com a mensagem inserida
    _messages.insert(0, msg);
    _messagesStreamController.add(List.from(_messages));
  }

  @override
  void dispose() {
    _messageStreamer.dispose();
    _messageSubscription?.cancel();
    _messagesStreamController.close();
    _listViewController.dispose();
    super.dispose();
  }

  Future<void> _printDatabaseTables() async {
    final conversationProvider =
        Provider.of<ConversationProvider>(context, listen: false);

    print("conversations = ");
    print(conversationProvider.conversations);

    final db = await _conversationProvider.database;

    List<Map<String, dynamic>> messages = await db.query('messages');
    List<Map<String, dynamic>> conversations = await db.query('conversations');

    print("Mensagens:");
    for (var row in messages) {
      print(row);
    }

    print("Conversas:");
    for (var row in conversations) {
      print(row);
    }
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
              onPressed: _printDatabaseTables,
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
                          bool isMe = message.senderId == 0;
                          return MessageBubble(
                            message: message,
                            isMe: isMe,
                            isGroupChat: widget.isGroupChat,
                          );
                        },
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
              ChatInputBar(
                onSendMessage: (messageContent) {
                  _sendMessage(messageContent);
                },
              ),
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
  final bool isGroupChat;

  const MessageBubble({
    required this.message,
    required this.isMe,
    required this.isGroupChat, // Adicionado para verificar se é um chat em grupo
    Key? key,
  }) : super(key: key);

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
            right: isMe ? 10 : 50, // Se não for sua, diminua a margem direita
          ),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.80,
          ),
          decoration: BoxDecoration(
            color: isMe ? primary2_75 : dark2,
            borderRadius: isMe
                ? const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                  )
                : const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isMe && isGroupChat)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Text(
                    // Nome do outro participante, ou você pode remover esse campo se não for necessário
                    "Desconhecido", // Substitua com a lógica para obter o nome do participante
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                ),
              Text(
                message.content ?? '', // Usa um texto vazio como fallback
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class MessageStreamer {
  final StreamController<Message> _messageController =
      StreamController<Message>();
  final ConversationProvider _conversationProvider;
  final ChatSimulator chatSimulator = ChatSimulator();
  StreamSubscription?
      _timerSubscription; // Adicionado para manter a referência à assinatura

  MessageStreamer(this._conversationProvider);

  Stream<Message> get messageStream => _messageController.stream;

  void startSimulation(int friendId) {
    final random = Random(DateTime.now().millisecondsSinceEpoch);

    _timerSubscription = Stream.periodic(
      Duration(seconds: (random.nextInt(12) + 3)),
    ).listen((_) async {
      final randomMessage = Message(
        id: null,
        friendId: friendId,
        senderId: friendId,
        content: chatSimulator.randomMessage,
        timestamp: DateTime.now(),
        status: MessageStatus.sent,
        type: MessageType.text,
      );

      Message insertedMessage =
          await _conversationProvider.addMessage(randomMessage);
      _messageController.add(insertedMessage);
    });
  }

  void dispose() {
    _timerSubscription?.cancel(); // Cancela a assinatura
    _messageController.close();
  }
}
