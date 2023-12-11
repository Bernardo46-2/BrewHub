import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:brewhub/welcome/login.dart';
import 'package:brewhub/welcome/register.dart';
import 'package:brewhub/style.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePage();
}

class _WelcomePage extends State<WelcomePage> {
  static const double componentsWidth = 340;

  @override
  Widget build(BuildContext ctx) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: dark3,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent, 
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          backgroundWelcome(ctx),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Logo Section
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
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
                            style: TextStyle(fontSize: 18, color: white50),
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
