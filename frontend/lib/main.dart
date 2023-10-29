import 'package:brewhub/models/friend.dart';
import 'package:brewhub/models/hub.dart';
import 'package:brewhub/style.dart';
import 'package:flutter/material.dart';
import 'package:brewhub/welcome/welcome.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => FriendsProvider()),
        ChangeNotifierProvider(create: (context) => HubsProvider()),
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
