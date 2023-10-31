import 'package:brewhub/home/about.dart';
import 'package:brewhub/style.dart';
import 'package:brewhub/welcome/welcome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {
  final String _photo = '';

  ImageProvider loadPhotoUrl(String photo) {
    if(photo.startsWith('http')) {
      return NetworkImage(photo, scale: 1);
    }
    return const AssetImage('assets/sigurd.jpeg');
  }
  
  Widget _buildSettingsItem(IconData icon, String text, void Function() onTap) {
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
      onTap: onTap
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
                GestureDetector(
                  child: CircleAvatar(
                    radius: 60,
                    // TODO: load url from user photo
                    backgroundImage: loadPhotoUrl(_photo),
                  ),
                  onTap: () {
                    showDialog(
                      context: ctx,
                      builder: (ctx) => ConfirmCancelModal(
                        title: 'Alterar Foto',
                        formPlaceholder: 'Url da foto',
                        invalidInputMsg: 'Campo url obrigatório',
                        action: (value) {
                          // TODO: store new photo
                        },
                      ),
                    );
                  }
                ),
                const SizedBox(height: 20),
                const Text(
                  'Sigurd',
                  style: TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'I work for Belethor, at the General Goods store.',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 40),
                Expanded(
                  child: ListView(
                    children: [
                      _buildSettingsItem(Icons.person, 'Alterar Nome', () {
                        showDialog(
                          context: ctx,
                          builder: (ctx) => ConfirmCancelModal(
                            title: 'Editar Nome',
                            formPlaceholder: 'Novo nome',
                            invalidInputMsg: 'Campo nome obrigatório',
                            action: (value) {
                              // TODO: store new name
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
                              // TODO: store new status
                            },
                          ),
                        );
                      }),
                      _buildSettingsItem(Icons.notifications, 'Notificações', () {}),
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
    required this.formPlaceholder,
    required this.action,
    required this.invalidInputMsg
  }) : super(key: key);

  final String title;
  final String formPlaceholder;
  final void Function(String) action;
  final String invalidInputMsg;

  @override
  State<ConfirmCancelModal> createState() => _ConfirmCancelModal();
}

class _ConfirmCancelModal extends State<ConfirmCancelModal> {
  _ConfirmCancelModal();
  
  final TextEditingController _nameController = TextEditingController();
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
            TextField(
              controller: _nameController,
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
                    if(_nameController.text.isNotEmpty) {
                      setState(() {
                        errorMessage = null;
                      });
                      widget.action(_nameController.text);
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
