import 'package:brewhub/colors.dart';
import 'package:flutter/material.dart';
import 'package:brewhub/login.dart';
import 'package:brewhub/register.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

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
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Logo Section
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          const CircleAvatar(
                            backgroundColor: primary6,
                            radius: 45,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 7),
                            child: Image.asset(
                              'assets/brewhub_logo.png',
                              width: 80,
                              height: 80,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 30),
                      Image.asset(
                        'assets/brewhub.png',
                        width: 220,
                        height: 220,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(child: Container()),
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: componentsWidth,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Bem-vindo (ou vinda) ao BrewHub',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Seu café virtual para conexões reais. Trabalhe, relaxe e conecte-se. Entre e faça parte da nossa comunidade!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(128, 255, 255, 255)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(componentsWidth, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
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
                    const SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: dark3,
                        minimumSize: const Size(componentsWidth, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
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
              ),
            ],
          ),
        ],
      ),
    );
  }
}
