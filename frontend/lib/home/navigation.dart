import 'package:brewhub/home/friends.dart';
import 'package:brewhub/home/hub.dart';
import 'package:brewhub/home/notifications.dart';
import 'package:brewhub/home/feed.dart';
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
    const FriendsPage(),
    const HubPage(),
    const NotificationsPage(),
    const FeedPage(),
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
            icon: Icon(Icons.people),
            label: 'Amigos',
          ),
          BottomNavigationBarItem(
            backgroundColor: dark3,
            icon: Icon(Icons.coffee),
            label: 'Hub',
          ),
          BottomNavigationBarItem(
            backgroundColor: dark3,
            icon: Icon(Icons.notifications),
            label: 'Notificações',
          ),
          BottomNavigationBarItem(
            backgroundColor: dark3,
            icon: Icon(Icons.timeline),
            label: 'Feed',
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
