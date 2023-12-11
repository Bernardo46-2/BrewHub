// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:brewhub/style.dart';

class ChatInputBar extends StatefulWidget {
  final Function(String) onSendMessage;

  const ChatInputBar({Key? key, required this.onSendMessage}) : super(key: key);

  @override
  _ChatInputBarState createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: dark3,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          Material(
            color: dark2_75,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              highlightColor: primary4,
              onTap: () {
                // TODO: Função para abrir emojis
              },
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(8.0),
                child: const Icon(Icons.insert_emoticon, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _controller, // Adicionado o controller
              maxLines: 5,
              minLines: 1,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.only(
                    left: 15, right: 5, top: 5, bottom: 5),
                hintText: 'Digite uma mensagem...',
                fillColor: dark2_75,
                hintStyle: const TextStyle(color: Colors.white70),
                suffixIcon: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    highlightColor: primary4,
                    splashColor: primary4,
                    onTap: () {
                      if (_controller.text.trim().isNotEmpty) {
                        widget.onSendMessage(_controller.text);
                        _controller.clear();
                      }
                    },
                    child: const Icon(Icons.send, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Material(
            color: dark2_75,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              splashColor: primary4,
              onTap: () {
                // TODO: Função para gravar áudio
              },
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(8.0),
                child: const Icon(Icons.mic, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
