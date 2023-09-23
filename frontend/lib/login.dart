import 'package:flutter/material.dart';
import 'package:brewhub/colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  final String title = "Login";

  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  static const double componentsWidth = 340;
  bool _pwdHidden = true;

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Opacity(
            opacity: .3,
            child: Image.asset(
              'assets/background.jpg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            )
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 70),
                const SizedBox(
                  width: componentsWidth,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Boas Vindas de Volta!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Prepare seu café, encontre seu espaço favorito e reconecte-se com a comunidade.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 35),
                const SizedBox(
                  width: componentsWidth,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'INFORMAÇÕES DE CONTA',
                        style: TextStyle(
                          fontSize: 18,
                          color: dark5,
                        )
                      )
                    ]
                  )
                ),
                const SizedBox(height: 5),
                Opacity(
                  opacity: .85,
                  child: SizedBox(
                    width: componentsWidth,
                    child: TextField(
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        height: .7
                      ),
                      decoration: InputDecoration(
                        labelText: 'E-mail ou número de telefone',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: const Icon(
                          Icons.account_circle_rounded,
                          color: Colors.white
                        ),
                      )
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Opacity(
                  opacity: .85,
                  child: SizedBox(
                    width: componentsWidth,
                    child: TextField(
                      obscureText: _pwdHidden,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        height: .7,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Colors.white
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _pwdHidden ? Icons.visibility : Icons.visibility_off,
                            color: Colors.white
                          ),
                          onPressed: () {
                            setState(() {
                            _pwdHidden = !_pwdHidden;
                            });
                          }
                        ),
                      )
                    ),
                  ), 
                ),
                const SizedBox(height: 15),
                GestureDetector(
                  onTap: () {
                    // TODO: handle forgot password
                  },
                  child: const SizedBox(
                    width: componentsWidth,
                    child: Text(
                      'Esqueceu sua senha?',
                      style: TextStyle(
                        color: feedbackBlue
                      )
                    )
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: componentsWidth,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          // TODO: handle login
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(componentsWidth, 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                          ),
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          )
                        )
                      ),
                    ]
                  )
                ),
                SizedBox(
                  width: componentsWidth,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          // TODO: handle login with google
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          minimumSize: const Size(componentsWidth, 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              'assets/google.png',
                              width: 24,
                              height: 24
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Logar com o Google',
                              style: TextStyle(
                                color: dark1,
                                fontSize: 15,
                              )
                            ),
                          ],
                        )
                      ),
                    ]
                  )
                )
              ],
            ),
          ),
          Positioned(
            bottom: 16,
            right: 10,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                elevation: 0
              ),
              child: const SizedBox(
                width: 40.0,
                height: 40.0,
                child: Center(
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
              )
            )
          )
        ]
      ),
    );
  }
}
