import 'package:brewhub/colors.dart';
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
  static const double componentsWidth = 340;

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Opacity(
            opacity: .3,
            child: Image.asset(
              'assets/background.jpg',
              fit: BoxFit.cover,
              width: MediaQuery.of(ctx).size.width,
              height: MediaQuery.of(ctx).size.height,
            )
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    const SizedBox(width: 25),
                    Stack(
                      children: <Widget>[
                        const CircleAvatar(
                          backgroundColor: primary6,
                          radius: 45
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 7),
                          child: Image.asset(
                            'assets/brewhub_logo.png',
                            width: 80,
                            height: 80,
                            fit: BoxFit.contain
                          ),
                        )
                      ]
                    ),
                    const SizedBox(width: 30),
                    Image.asset(
                      'assets/brewhub.png',
                      width: 220,
                      height: 220,
                      fit: BoxFit.contain
                    ),
                  ],
                ),
                Positioned(
                  bottom: 50,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(componentsWidth, 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                          ),
                        ),
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
                        style: ElevatedButton.styleFrom(
                          backgroundColor: dark3,
                          minimumSize: const Size(componentsWidth, 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(ctx).push(
                            MaterialPageRoute(
                              builder: (ctx) => const RegisterPage(),
                            ),
                          );
                        },
                        child: const Text('Register'),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ), 
        ]
      )
    );
  }
}
