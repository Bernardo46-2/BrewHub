import 'package:bonfire/bonfire.dart';
import 'package:brewhub/game/game_sprite_sheet.dart';

class BrewHubPlayer extends SimplePlayer with ObjectCollision {
  BrewHubPlayer(Vector2 position) : super(
    animation: SimpleDirectionAnimation(
      idleRight: GameSpriteShit.playerIdleRight, 
      runRight: GameSpriteShit.playerRunRight
    ),
    position: position,
    size: Vector2.all(80),
    speed: 200,
  ) {
    setupCollision(
      CollisionConfig(
        collisions: [
          CollisionArea.rectangle(
            size: Vector2(32, 40),
            align: Vector2(24, 30)
          )
        ]
      )
    );
  }
}
