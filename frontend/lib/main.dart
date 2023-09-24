import 'package:brewhub/style.dart';
import 'package:flutter/material.dart';
import 'package:brewhub/welcome.dart';

void main() {
  runApp(const BrewHub());
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
