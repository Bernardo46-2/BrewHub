import 'package:bonfire/bonfire.dart';

final Vector2 playerSize = Vector2(32, 32);

class GameSpriteShit {
  static Future<SpriteAnimation> get playerIdleRight => SpriteAnimation.load(
    'fPlayer_elf.png',
    SpriteAnimationData.sequenced(
      amount: 4, 
      stepTime: 0.15, 
      textureSize: playerSize,
      texturePosition: Vector2(0, 32)
    ),
  );

  static Future<SpriteAnimation> get playerRunRight => SpriteAnimation.load(
    'fPlayer_elf.png',
    SpriteAnimationData.sequenced(
      amount: 8, 
      stepTime: 0.15, 
      textureSize: playerSize,
      texturePosition: Vector2(0, 64)
    ),
  );
}
