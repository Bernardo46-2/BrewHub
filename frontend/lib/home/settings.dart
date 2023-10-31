import 'package:brewhub/home/about.dart';
import 'package:brewhub/style.dart';
import 'package:brewhub/welcome/welcome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {
  static const String _photoUrlKey = 'photoUrl';
  static const String _nameKey = 'nick';
  static const String _statusKey = 'status';
  String _photoUrl = '';
  String _name = '';
  String _status = '';

  ImageProvider loadPhotoUrl(String photo) {
    if(photo.startsWith('http')) {
      return NetworkImage(photo, scale: 1);
    }
    return const AssetImage('assets/doggo.jpg');
  }
  
  Future<void> initValue(void Function(String?) pred, String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    pred(prefs.getString(key));
  }

  Future<void> saveValue(void Function() pred, String key, String value) async {
    pred();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<void> removeValue(void Function() pred, String key) async {
    pred();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
  
  Widget _buildSettingsItem(IconData icon, String text, void Function() pred) {
    return ListTile(
      leading: Icon(
        icon, 
        color: Colors.white
      ),
      title: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: Colors.white
      ),
      onTap: pred
    );
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: dark3,
        automaticallyImplyLeading: false,
        title: const Text("Configurações"),
        actions: <Widget>[
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
            width: 40,
            decoration: BoxDecoration(
              color: primary4_75,
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: const Icon(Icons.info_outline, color: Colors.white),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => const AboutPage(),
                );
              },
            ),
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          backgroundHome(ctx),
          Center(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 40),
                FutureBuilder(
                  future: initValue((value) { _photoUrl = value ?? _photoUrl; }, _photoUrlKey),
                  builder: (context, snapshot) {
                    if(snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    return GestureDetector(
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: loadPhotoUrl(_photoUrl),
                      ),
                      onTap: () {
                        showDialog(
                          context: ctx,
                          builder: (ctx) => ConfirmCancelModal(
                            title: 'Alterar Foto',
                            formPlaceholder: 'Url da foto',
                            invalidInputMsg: 'Campo url obrigatório',
                            action: (value) {
                              setState(() {
                                saveValue(() { _photoUrl = value; }, _photoUrlKey, value);
                              });
                            }
                          ),
                        );
                      },
                      onLongPress: () {
                        showDialog(
                          context: ctx,
                          builder: (ctx) => ConfirmCancelModal(
                            title: 'Remover foto?',
                            action: (_) {
                              setState(() {
                                removeValue(() { _photoUrl = ''; }, _photoUrlKey);
                              });
                            }
                          ),
                        );
                      }
                    );
                  },
                ),
                const SizedBox(height: 20),
                FutureBuilder(
                  future: initValue((value) { _name = value ?? _name; }, _nameKey),
                  builder: (context, snapshot) {
                    if(snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    return Text(
                      _name,
                      style: const TextStyle(
                        fontSize: 18, 
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      ),
                    );
                  }
                ),
                const SizedBox(height: 10),
                FutureBuilder(
                  future: initValue((value) { _status = value ?? _status; }, _statusKey),
                  builder: (context, snapshot) {
                    if(snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    return Text(
                      _status,
                      style: const TextStyle(
                        fontSize: 14, 
                        color: Colors.grey
                      ),
                    );
                  }
                ),
                const SizedBox(height: 40),
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      _buildSettingsItem(Icons.person, 'Alterar Nome', () {
                        showDialog(
                          context: ctx,
                          builder: (ctx) => ConfirmCancelModal(
                            title: 'Editar Nome',
                            formPlaceholder: 'Novo nome',
                            invalidInputMsg: 'Campo nome obrigatório',
                            action: (value) {
                              setState(() {
                                saveValue(() { _name = value; }, _nameKey, value);
                              });
                            },
                          ),
                        );
                      }),
                      _buildSettingsItem(Icons.edit, 'Definir Status', () {
                        showDialog(
                          context: ctx,
                          builder: (ctx) => ConfirmCancelModal(
                            title: 'Editar Status',
                            formPlaceholder: 'Novo status',
                            invalidInputMsg: 'Campo status obrigatório',
                            action: (value) {
                              setState(() {
                                saveValue(() { _status = value; }, _statusKey, value);
                              });
                            },
                          ),
                        );
                      }),
                      _buildSettingsItem(Icons.exit_to_app, 'Sair', () {
                        FirebaseAuth.instance.signOut();
                        Navigator.of(ctx).push(
                          MaterialPageRoute(
                            builder: (ctx) => const WelcomePage()
                          )
                        );
                      }),
                    ],
                  ),
                ),
              ]
            ),
          ),
        ],
      ),
    );
  }
}

class ConfirmCancelModal extends StatefulWidget {
  const ConfirmCancelModal({
    Key? key,
    required this.title,
    this.formPlaceholder,
    required this.action,
    this.invalidInputMsg
  }) : super(key: key);

  final String title;
  final String? formPlaceholder;
  final void Function(String) action;
  final String? invalidInputMsg;

  @override
  State<ConfirmCancelModal> createState() => _ConfirmCancelModal();
}

class _ConfirmCancelModal extends State<ConfirmCancelModal> {
  final TextEditingController _inputController = TextEditingController();
  String? errorMessage;
  
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: dark3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 3, bottom: 18),
              child: Text(
                widget.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: white85,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if(widget.formPlaceholder != null) TextField(
              controller: _inputController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.person, color: Colors.white),
                labelText: widget.formPlaceholder,
                labelStyle: const TextStyle(color: white75),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                fillColor: dark2_75,
              ),
            ),
            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              )
            else
              const SizedBox.shrink(),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: feedbackBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Confirmar'),
                  onPressed: () {
                    if(_inputController.text.isNotEmpty || (widget.formPlaceholder == null && widget.invalidInputMsg == null)) {
                      setState(() {
                        errorMessage = null;
                      });
                      widget.action(_inputController.text);
                      Navigator.pop(context);
                    } else {
                      setState(() {
                        errorMessage = widget.invalidInputMsg;
                      });
                    }
                  }
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: feedbackRed,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Cancelar'),
                  onPressed: () {
                    setState(() {
                      errorMessage = null;
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class SharedPreferencesProvider extends ChangeNotifier {
  SharedPreferences? _prefs;

  SharedPreferences? get prefs => _prefs;

  SharedPreferencesProvider() {
    initSharedPreferences();
  }

  Future<void> initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    notifyListeners();
  }
}
