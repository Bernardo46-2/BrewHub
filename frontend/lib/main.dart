import 'package:brewhub/colors.dart';
import 'package:flutter/material.dart';
import 'package:brewhub/welcome.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BrewHub',
      theme: brewHubTheme,
      home: const WelcomePage(title: 'BrewHub'),
      debugShowCheckedModeBanner: false,
    );
  }
}
