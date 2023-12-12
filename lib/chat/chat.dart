// ignore_for_file: library_private_types_in_public_api

import 'dart:async';
import 'package:brewhub/chat/input_bar.dart';
import 'package:brewhub/chat/video_call.dart';
import 'package:brewhub/models/friend.dart';
import 'package:brewhub/models/message.dart';
import 'package:brewhub/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int selfId = -1;
  String chatId = "-1";

  @override
  void initState() {
    super.initState();
    _initializeConversation();
  }

  Future<void> _initializeConversation() async {
    await ensureConversationExists(widget.friend.id);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    selfId = int.parse(prefs.getString('id') ?? "-2");
    chatId = getChatId(selfId, widget.friend.id);

    _messageStreamer = MessageStreamer(chatId);
    _fetchMessages();
    _messageStreamer.startListeningForMessages();
    _messageStreamer.messageStream.listen((message) {
      if (!_messagesStreamController.isClosed && message.senderId != selfId) {
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

  String getChatId(int userId1, int userId2) {
    return userId1 < userId2 ? '${userId1}_$userId2' : '${userId2}_$userId1';
  }

  Future<void> _sendMessage(String messageContent) async {
    DocumentReference chatDoc =
        _firestore.collection('conversations').doc(chatId);

    final newMessage = Message(
      id: null,
      friendId: widget.friend.id,
      senderId: selfId,
      content: messageContent,
      timestamp: DateTime.now(),
      status: MessageStatus.notSent,
      type: MessageType.text,
    );

    Message msg = await _conversationProvider.addMessage(newMessage);

    await chatDoc.collection('messages').add(newMessage.toMap());

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
              onPressed: () async {
                // Pausa a simulação de mensagens
                _messageStreamer.pauseSimulation();

                // Navega para a tela de ligação
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        VideoCallScreen(friend: widget.friend),
                  ),
                );

                // Retoma a simulação de mensagens ao retornar
                _messageStreamer.resumeSimulation();
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
                          return MessageBubble(
                            message: message,
                            selfId: selfId,
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
  final int selfId;
  final bool isGroupChat;

  const MessageBubble({
    required this.message,
    required this.selfId,
    required this.isGroupChat, // Adicionado para verificar se é um chat em grupo
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isMe = message.senderId == selfId;
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
  final String chatId;
  final ChatSimulator chatSimulator = ChatSimulator();
  StreamSubscription?
      _timerSubscription; // Adicionado para manter a referência à assinatura

  MessageStreamer(this.chatId);

  Stream<Message> get messageStream => _messageController.stream;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StreamSubscription? _firestoreSubscription;

  void startListeningForMessages() {
    DocumentReference chatDoc =
        _firestore.collection('conversations').doc(chatId);

    _firestoreSubscription?.cancel(); // Cancela qualquer listener existente

    _firestoreSubscription = chatDoc
        .collection('messages')
        .orderBy('timestamp')
        .snapshots()
        .listen((snapshot) {
      for (var docChange in snapshot.docChanges) {
        if (docChange.type == DocumentChangeType.added) {
          var messageData = docChange.doc.data() as Map<String, dynamic>;
          var message = Message.fromMap(messageData);
          _messageController.add(message);
        }
      }
    });
  }

  void pauseSimulation() {
    _timerSubscription?.pause();
  }

  // Método para retomar a simulação
  void resumeSimulation() {
    _timerSubscription?.resume();
  }

  void dispose() {
    _timerSubscription?.cancel(); // Cancela a assinatura
    _messageController.close();
  }
}
