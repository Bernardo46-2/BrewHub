import 'package:brewhub/style.dart';
import 'package:flutter/material.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPage();
}

class _ChatListPage extends State<ChatListPage> {
  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          backgroundHome(ctx),
          const Center(child: Text("Conversas")),
        ],
      ),
    );
  }
}
