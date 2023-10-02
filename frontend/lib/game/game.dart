import 'package:bonfire/bonfire.dart';
import 'package:brewhub/game/bonfire_override/my_joystick.dart';
import 'package:brewhub/game/bonfire_override/my_joystick_directional.dart';
import 'package:brewhub/style.dart';
import 'package:flutter/material.dart';

class MyGame extends StatelessWidget {
  const MyGame({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Jogo
          BonfireWidget(
            joystick: MyJoystick(
              directional: MyJoystickDirectional(),
            ),
            map: WorldMapByTiled(
              'map/mapa.tmj',
              forceTileSize: Vector2(32, 32),
            ),
          ),

          // Barra inferior
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                color: dark3,
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Botão de voltar
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),

                    // Outros elementos irao aqui
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
