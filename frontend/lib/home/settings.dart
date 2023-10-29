import 'package:brewhub/home/about.dart';
import 'package:brewhub/style.dart';
import 'package:brewhub/welcome/welcome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {
  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: dark3,
        automaticallyImplyLeading: false,
        title: const Text("Configurações"),
        actions: [
          TextButton(
            onPressed: () {
              // Navigate to the AboutPage when the button is pressed.
              Navigator.of(ctx).push(
                MaterialPageRoute(builder: (ctx) => const AboutPage()),
              );
            },
            child: const Text(
              "Sobre",
              style: TextStyle(
                color: Colors.white, // Customize the button text color.
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          backgroundHome(ctx),
          Center(
            child: Column(
              children: <Widget>[
                const Text("Settings"),
                TextButton(
                  child:
                      const Text("Sair", style: TextStyle(color: primary4)),
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.of(ctx).push(MaterialPageRoute(
                      builder: (ctx) => const WelcomePage()
                    ));
                  },
                )
              ]
            ),
          ),
        ],
      ),
    );
  }
}
