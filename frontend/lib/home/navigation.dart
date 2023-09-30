import 'package:brewhub/home/friends.dart';
import 'package:brewhub/home/hubs.dart';
import 'package:brewhub/home/chat_list.dart';
import 'package:brewhub/home/settings.dart';
import 'package:brewhub/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _Nav();
}

class _Nav extends State<Navigation> {
  int _currentIndex = 0;

  final List<Widget> pages = [
    const HubPage(),
    const FriendsPage(),
    const ChatListPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext ctx) {
    // Atualizando a cor da barra de sistema
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: dark3,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: primary4, // cor do item selecionado
        unselectedItemColor: primary6,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            backgroundColor: dark3,
            icon: Icon(Icons.coffee),
            label: 'Hub',
          ),
          BottomNavigationBarItem(
            backgroundColor: dark3,
            icon: Icon(Icons.people),
            label: 'Amigos',
          ),
          BottomNavigationBarItem(
            backgroundColor: dark3,
            icon: Icon(Icons.chat_bubble),
            label: 'Conversas',
          ),
          BottomNavigationBarItem(
            backgroundColor: dark3,
            icon: Icon(Icons.settings),
            label: 'Configurações',
          ),
        ],
      ),
    );
  }
}
