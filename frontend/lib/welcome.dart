import 'package:flutter/material.dart';
import 'package:brewhub/login.dart';
import 'package:brewhub/register.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key, required this.title});

  final String title;

  @override
  State<WelcomePage> createState() => _WelcomePage();
}

class _WelcomePage extends State<WelcomePage> {
  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).push(
                  MaterialPageRoute(
                    builder: (ctx) => const LoginPage(),
                  ),
                );
              },
              child: const Text('Login'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).push(
                  MaterialPageRoute(
                    builder: (ctx) => const RegisterPage(),
                  ),
                );
              },
              child: const Text('Register'),
            )
          ],
        ),
      ),
    );
  }
}
