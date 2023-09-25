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
                  'assets/brewhub_logo.png', // Replace with the actual path to your image.
                  width: 100, // Set the width of the image as needed.
                  height: 100, // Set the height of the image as needed.
                ),
                Container(
                  padding: const EdgeInsets.all(
                      20.0), // Add padding to create a block-like appearance.
                  alignment: Alignment.center, // Center the text.
                  child: const Text(
                    "O BrewHub é uma plataforma gamificada de escritório virtual, inspirada na atmosfera de cafés coworking, que visa proporcionar um ambiente virtual colaborativo e descontraído.",
                    style: TextStyle(
                      fontSize: 18, // Customize the font size.
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.left, // Center the text leftsie.
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(
                      20.0), // Add padding to create a block-like appearance.
                  alignment: Alignment.center, // Center the text.
                  child: const Text(
                    "Sua finalidade principal é reaproximar trabalhadores em home office, especialmente programadores e entusiastas da tecnologia, em um espaço digital onde podem trabalhar, se conectar e relaxar, combinando elementos de trabalho e lazer em um único ambiente.",
                    style: TextStyle(
                      fontSize: 18, // Customize the font size.
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.left, // Center the text leftsie.
                  ),
                ),
                const SizedBox(height: 20.0), // Add space between text blocks.
                const Text(
                  "Carefully crafted by",
                  style: TextStyle(
                      fontSize: 18, // Customize the font size.
                      color: Colors.white),
                ),
                const Text(
                  "Tony LuckyStriker, Rusty B, and Haikai Pepe",
                  style: TextStyle(
                      fontSize: 18, // Customize the font size.
                      color: Colors.white),
                ),
                const Text(
                  "All rights reserved, BrewHub™",
                  style: TextStyle(
                      fontSize: 18, // Customize the font size.
                      color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
