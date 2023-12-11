import 'package:brewhub/models/message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:brewhub/style.dart';
import 'package:brewhub/home/navigation.dart';
import 'package:brewhub/models/friend.dart';
import 'package:brewhub/models/hub.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  static const double componentsWidth = 340;
  bool _pwdHidden = true;
  bool _imgHidden = true;
  final GlobalKey<_FadingImageState> fadingImageKey = GlobalKey();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email = '';
  String _pwd = '';

  Future<bool> tryLoginUser(String email, String pwd) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email, 
        password: pwd
      );
      print("User logged in: ${userCredential.user?.uid}");
      return true;
    } catch(e) {
      print("Login error: $e");
      return false;
    }
  }

  void loginUser(BuildContext ctx) async {
    final navigator = Navigator.of(ctx);
    final friendsProvider = Provider.of<FriendsProvider>(ctx, listen: false);
    final hubsProvider = Provider.of<HubsProvider>(ctx, listen: false);
    final conversationProvider = Provider.of<ConversationProvider>(ctx, listen: false);

    if(await tryLoginUser(_email, _pwd)) {
      await friendsProvider.initializeDatabase();
      await friendsProvider.checkAndInsertInitialFriends();

      await hubsProvider.initializeDatabase();
      await hubsProvider.checkAndInsertInitialHubs();

      await hubsProvider.fetchAndSetHubs();
      await friendsProvider.fetchAndSetFriends();
      await conversationProvider.fetchAndSetConversations();

      navigator.push(
        MaterialPageRoute(
          builder: (ctx) => const Navigation(),
        ),
      );
    } else {
      // TODO: display login error
    }
  }

  @override
  Widget build(BuildContext ctx) {
    return GestureDetector(
        onTap: FocusScope.of(ctx).unfocus,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(children: <Widget>[
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
                          style: TextStyle(fontSize: 18, color: white50),
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
                            Text('INFORMAÇÕES DE CONTA',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: dark5,
                                ))
                          ])),
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
                                color: Colors.white, fontSize: 18, height: .7),
                              decoration: InputDecoration(
                                labelText: 'Email',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                prefixIcon: const Icon(Icons.account_circle_rounded, color: Colors.white),
                              ),
                              onSaved: (value) {
                                _email = value ?? _email;
                              },
                              validator: (value) {
                                if(value == '') {
                                  return null;
                                }
                                if(value != null && !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$").hasMatch(value)) {
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
                                prefixIcon:
                                  const Icon(Icons.lock, color: Colors.white),
                                suffixIcon: IconButton(
                                  icon: Icon(_pwdHidden ? Icons.visibility : Icons.visibility_off, color: Colors.white),
                                  onPressed: () {
                                    setState(() {
                                      _pwdHidden = !_pwdHidden;
                                    });
                                  }
                                ),
                              ),
                              onSaved: (value) {
                                _pwd = value ?? _pwd;
                              },
                              validator: (value) {
                                if(value == null || value.isEmpty) {
                                  return 'Senha não pode ficar vazia';
                                }
                                if(value != 'doggo' && !RegExp(r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$").hasMatch(value)) {
                                  return 'A senha deve ter no mínimo 8 caracteres, uma letra maiúscula, uma minúscula e um número';
                                }
                                return null;
                              }
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
                              child: Text('Esqueceu sua senha?',
                                  style: TextStyle(color: feedbackBlue))),
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
                                          
                                          if (_imgHidden && _email == '' && _pwd == 'doggo') {
                                            fadingImageKey.currentState?.fadeIn();
                                            _imgHidden = false;
                                          } else {
                                            loginUser(ctx);
                                          }
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: const Size(componentsWidth, 40),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10)),
                                      ),
                                      child: const Text('Login',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ))),
                                ])),
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
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Image.asset('assets/google.png',
                                        width: 24, height: 24),
                                    const SizedBox(width: 8),
                                    const Text('Logar com o Google',
                                        style: TextStyle(
                                          color: dark1,
                                          fontSize: 15,
                                        )),
                                  ],
                                )),
                          ])),
                  const SizedBox(height: 50),
                  _FadingImage(key: fadingImageKey),
                ],
              ),
            ),
            Positioned(
                bottom: 16,
                right: 10,
                child: ElevatedButton(
                    onPressed: Navigator.of(ctx).pop,
                    style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(), elevation: 0),
                    child: const SizedBox(
                      width: 40.0,
                      height: 40.0,
                      child: Center(
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                    )))
          ]),
        ));
  }
}

class _FadingImage extends StatefulWidget {
  const _FadingImage({required key}) : super(key: key);

  @override
  _FadingImageState createState() => _FadingImageState();
}

class _FadingImageState extends State<_FadingImage> {
  double opacity = 0;

  void fadeIn() {
    setState(() {
      opacity = 1;
    });
  }

  @override
  Widget build(BuildContext ctx) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          AnimatedOpacity(
              opacity: opacity,
              duration: const Duration(seconds: 3),
              child: Image.asset('assets/doggo.jpg', fit: BoxFit.contain))
        ]);
  }
}
