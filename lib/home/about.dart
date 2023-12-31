import 'package:brewhub/style.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPage();
}

class _AboutPage extends State<AboutPage> {
  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: dark3,
        automaticallyImplyLeading: false,
        title: const Text("Brewhub, 2023"),
        leading: const BackButton(color: Colors.white),
      ),
      body: Stack(
        children: <Widget>[
          backgroundHome(ctx),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/brewhub_logo.png',
                  width: 100,
                  height: 100,
                ),
                Container(
                  padding: const EdgeInsets.all(20.0),
                  alignment: Alignment.center,
                  child: const Text(
                    "O BrewHub é uma plataforma gamificada de escritório virtual, inspirada na atmosfera de cafés coworking, que visa proporcionar um ambiente virtual colaborativo e descontraído.",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20.0),
                  alignment: Alignment.center,
                  child: const Text(
                    "Sua finalidade principal é reaproximar trabalhadores em home office, especialmente programadores e entusiastas da tecnologia, em um espaço digital onde podem trabalhar, se conectar e relaxar, combinando elementos de trabalho e lazer em um único ambiente.",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                const SizedBox(height: 20.0),
                const Text(
                  "Carefully crafted by",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                const Text(
                  "Tony LuckyStriker, Rusty B, and Haikai Pepe",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                const Text(
                  "All rights reserved, BrewHub™",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
