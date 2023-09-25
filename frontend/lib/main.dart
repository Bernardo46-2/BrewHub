import 'package:brewhub/models/friend.dart';
import 'package:brewhub/style.dart';
import 'package:flutter/material.dart';
import 'package:brewhub/welcome/welcome.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => FriendsProvider()), // Crie uma instância do FriendsProvider
        // Adicione outros providers, se necessário
      ],
      child: const BrewHub(),
    ),
  );
}

class BrewHub extends StatelessWidget {
  const BrewHub({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BrewHub',
      theme: brewHubTheme,
      home: const WelcomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
