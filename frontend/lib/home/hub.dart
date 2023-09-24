import 'package:brewhub/style.dart';
import 'package:flutter/material.dart';

class HubPage extends StatefulWidget {
  const HubPage({super.key});

  @override
  State<HubPage> createState() => _HubPage();
}

class _HubPage extends State<HubPage> {
  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          backgroundHome(ctx),
          const Center(child: Text("Hub")),
        ],
      ),
    );
  }
}
