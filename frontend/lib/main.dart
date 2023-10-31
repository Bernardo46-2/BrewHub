import 'package:brewhub/home/navigation.dart';
import 'package:brewhub/models/friend.dart';
import 'package:brewhub/models/hub.dart';
import 'package:brewhub/style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:brewhub/welcome/welcome.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

// TODO: login automatically if user already logged in once
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

class BrewHub extends StatefulWidget {
  const BrewHub({super.key});
  
  @override
  State<BrewHub> createState() => _BrewHub();
}

class _BrewHub extends State<BrewHub> {
  FirebaseAuth auth = FirebaseAuth.instance;
  bool isLogged = false;
  
  Future<void> testLogin() async {
    auth.authStateChanges().listen((User? user) {
      if(user != null && mounted) {
        setState(() {
          isLogged = true;
        });
      }
    });
  }

  @override
  void initState() {
    testLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BrewHub',
      theme: brewHubTheme,
      home: isLogged ? const Navigation() : const WelcomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
