import 'package:brewhub/style.dart';
import 'package:flutter/material.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPage();
}

class _FeedPage extends State<FeedPage> {
  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          backgroundHome(ctx),
          const Center(child: Text("Feed")),
        ],
      ),
    );
  }
}
