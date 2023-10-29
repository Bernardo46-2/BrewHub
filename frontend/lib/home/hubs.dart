import 'package:brewhub/game/game.dart';
import 'package:brewhub/style.dart';
import 'package:flutter/material.dart';

class HubPage extends StatefulWidget {
  const HubPage({super.key});

  @override
  State<HubPage> createState() => _HubPageState();
}

class _HubPageState extends State<HubPage> {
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
                // TODO: Botão de adicionar HUB
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
            itemCount: hubs.length,
            itemBuilder: (context, index) => HubBlock(hub: hubs[index]),
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
                hub.imagePath,
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

class Hub {
  final String name;
  final String imagePath;
  final int onlineCount;
  final int totalCount;
  final IconData icon;

  Hub({
    required this.name,
    required this.imagePath,
    required this.onlineCount,
    required this.totalCount,
    required this.icon,
  });
}

final hubs = [
  Hub(
    name: 'Exemplo Hub 1',
    imagePath: 'assets/hub/hub1.png',
    onlineCount: 23,
    totalCount: 70,
    icon: Icons.business,
  ),
  Hub(
    name: 'Exemplo Hub 2',
    imagePath: 'assets/hub/hub2.png',
    onlineCount: 23,
    totalCount: 70,
    icon: Icons.business,
  ),
  Hub(
    name: 'Exemplo Hub 3',
    imagePath: 'assets/hub/hub3.png',
    onlineCount: 23,
    totalCount: 70,
    icon: Icons.business,
  ),
];
