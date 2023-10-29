import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:brewhub/style.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPage();
}

class _RegisterPage extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  static const double componentsWidth = 340;
  bool _pwdHidden = true;
  bool _pwdHidden2 = true;
  final TextEditingController _pwdController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String email = '';
  String nick = '';
  String pwd = '';
  String pwd2 = '';

  // TODO: print if email is already in use
  Future<void> registerUser() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: pwd,
      );
      User? user = userCredential.user;
      await _firestore.collection('users').doc(user?.uid).set({
        'nick': nick,
      });
      print("User created: ${user?.uid}");
      
    } catch (e) {
      print("Register error: $e");
    }
  }

  @override
  Widget build(BuildContext ctx) {
    return GestureDetector(
      onTap: FocusScope.of(ctx).unfocus,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: <Widget>[
            backgroundWelcome(ctx),
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
                          'Dê o primeiro passo para se tornar um Brewer!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Conecte. Colabore. Crie.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: white50
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
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Opacity(
                          opacity: .85,
                          child: SizedBox(
                            width: componentsWidth,
                            child: TextFormField(
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                height: .7
                              ),
                              decoration: InputDecoration(
                                labelText: 'Email',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                prefixIcon: const Icon(
                                  Icons.account_circle_rounded,
                                  color: Colors.white
                                ),
                              ),
                              onSaved: (value) {
                                email = value ?? email;
                              },
                              validator: (value) {
                                if(value == null || value.isEmpty) {
                                  return 'Email não pode ficar vazio';
                                }
                                if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$").hasMatch(value)) {
                                  return 'Digite um email válido';
                                }
                                return null;
                              }
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Opacity(
                          opacity: .85,
                          child: SizedBox(
                            width: componentsWidth,
                            child: TextFormField(
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                height: .7
                              ),
                              decoration: InputDecoration(
                                labelText: 'Usuário',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                prefixIcon: const Icon(
                                  Icons.account_circle_rounded,
                                  color: Colors.white
                                ),
                              ),
                              onSaved: (value) {
                                nick = value ?? nick;
                              },
                              validator: (value) {
                                if(value == null || value.isEmpty) {
                                  return 'Usuário não pode ficar vazio';
                                }
                                if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9._%-]+$").hasMatch(value)) {
                                  return 'Digite um usuário válido';
                                }
                                return null;
                              }
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Opacity(
                          opacity: .85,
                          child: SizedBox(
                            width: componentsWidth,
                            child: TextFormField(
                              obscureText: _pwdHidden,
                              controller: _pwdController,
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
                              ),
                              onSaved: (value) {
                                pwd = value ?? pwd;
                              },
                              validator: (value) {
                                if(value == null || value.isEmpty) {
                                  return 'Senha não pode ficar vazia';
                                }
                                if(!RegExp(r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$").hasMatch(value)) {
                                  return 'A senha deve ter no mínimo 8 caracteres, uma letra maiúscula, uma minúscula e um número';
                                }
                                return null;
                              }
                            ),
                          ), 
                        ),
                        const SizedBox(height: 10),
                        Opacity(
                          opacity: .85,
                          child: SizedBox(
                            width: componentsWidth,
                            child: TextFormField(
                              obscureText: _pwdHidden2,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                height: .7,
                              ),
                              decoration: InputDecoration(
                                labelText: 'Confirme sua senha',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                prefixIcon: const Icon(
                                  Icons.lock,
                                  color: Colors.white
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _pwdHidden2 ? Icons.visibility : Icons.visibility_off,
                                    color: Colors.white
                                  ),
                                  onPressed: () {
                                    setState(() {
                                    _pwdHidden2 = !_pwdHidden2;
                                    });
                                  }
                                ),
                              ),
                              onSaved: (value) {
                                pwd2 = value ?? pwd2;
                              },
                              validator: (value) {
                                if(value == null || value.isEmpty) {
                                  return 'Senha não pode ficar vazia';
                                }
                                if(value != _pwdController.text) {
                                  return 'Confirmação de senha incorreta';
                                }
                                return null;
                              }
                            ),
                          ), 
                        ),
                        const SizedBox(height: 15),
                        GestureDetector(
                          onTap: () {
                            // TODO: handle show privacy policy
                          },
                          child: const SizedBox(
                            width: componentsWidth,
                            child: Text(
                              'Leia nossa política de privacidade',
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
                                  if(_formKey.currentState != null && _formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    registerUser();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(componentsWidth, 40),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                ),
                                child: const Text(
                                  'Cadastrar-se',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  )
                                )
                              ),
                            ]
                          )
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
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
                                'Cadastrar-se com o Google',
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
      ),
    );
  }
}
