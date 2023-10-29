import 'package:brewhub/game/game.dart';
import 'package:brewhub/style.dart';
import 'package:brewhub/models/hub.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HubPage extends StatefulWidget {
  const HubPage({Key? key}) : super(key: key);

  @override
  State<HubPage> createState() => _HubPageState();
}

class _HubPageState extends State<HubPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<HubsProvider>(context, listen: false).fetchAndSetHubs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: dark3,
        automaticallyImplyLeading: false,
        title: const Text("Amigos"),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
            width: 40,
            decoration: BoxDecoration(
              color: primary4_75,
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: const Icon(Icons.person_add, color: Colors.white),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => const AddHubModal(),
                );
              },
            ),
          ),
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          backgroundHome(context),
          ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: Provider.of<HubsProvider>(context).hubs.length,
            itemBuilder: (context, index) =>
                HubBlock(hub: Provider.of<HubsProvider>(context).hubs[index]),
          ),
        ],
      ),
    );
  }
}

class HubBlock extends StatelessWidget {
  final Hub hub;

  const HubBlock({required this.hub, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      width: double.infinity,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
            child: SizedBox(
              height: 170, // Altura ajustada
              child: Image.asset(
                hub.imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: dark3,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 12),
                          child: Text(
                            hub.name,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 30),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '${hub.onlineCount} Online - ${hub.totalCount} Membros',
                          style: const TextStyle(color: white50),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      // Adicione este Container
                      margin: const EdgeInsets.all(12),
                      child: Material(
                        color: primary4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: InkWell(
                          highlightColor: primary6,
                          splashColor: primary6,
                          borderRadius: BorderRadius.circular(8),
                          onTap: () {
                            // Navegue para a página FriendsPage.
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const MyGame(),
                              ),
                            );
                            const MyGame();
                          },
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            child: const Icon(Icons.arrow_forward,
                                color: Colors.white, size: 24),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Align(
                alignment: const Alignment(-0.9, 0),
                child: FractionalTranslation(
                  translation: const Offset(0, -0.7),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: primary4,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: dark3, width: 4),
                    ),
                    child: Icon(hub.icon, color: Colors.white, size: 32),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AddHubModal extends StatefulWidget {
  const AddHubModal({super.key});

  @override
  State<AddHubModal> createState() => _AddHubModalState();
}

class _AddHubModalState extends State<AddHubModal> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
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
            const Padding(
              padding: EdgeInsets.only(top: 3, bottom: 18),
              child: Text(
                'Adicionar Hub',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: white85,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Para o campo "Nome do Hub":
            TextField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.group, color: Colors.white), // Ícone de grupo
                labelText: 'Nome do Hub',
                labelStyle: const TextStyle(color: white75),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                fillColor: dark2_75,
              ),
            ),
            const SizedBox(height: 10),
            // Para o campo "ID do Hub":
            TextField(
              controller: _idController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.tag, color: Colors.white), // Ícone '#'
                labelText: 'ID do Hub',
                labelStyle: const TextStyle(color: white75),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                fillColor: dark2_75,
              ),
              keyboardType: TextInputType.number,
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
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('Adicionar'),
                onPressed: () {
                  if (_nameController.text.isNotEmpty &&
                      _idController.text.isNotEmpty) {
                    final hubId = int.tryParse(_idController.text);
                    if (hubId != null) {
                      final newHub = Hub(
                        id: hubId,
                        name: _nameController.text,
                        imageUrl: 'assets/hub/default.png', // Imagem padrão para Hubs
                        onlineCount: 0, // Inicialmente 0
                        totalCount: 0,  // Inicialmente 0
                        icon: Icons.business, // ícone padrão
                      );
                      Provider.of<HubsProvider>(context, listen: false).addHub(newHub);
                      setState(() {
                        errorMessage = null;
                      });
                      Navigator.of(context).pop();
                    } else {
                      setState(() {
                        errorMessage = 'ID do Hub inválido!';
                      });
                    }
                  } else {
                    setState(() {
                      errorMessage = 'Ambos os campos são obrigatórios!';
                    });
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
