import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'karakter.dart';
import 'oyun.dart';

class Dusman extends SpriteAnimationComponent with HasGameRef<BenimOyunum>, CollisionCallbacks {
  final double _hareketHizi = 200;
  
  // --- YENİ: SKOR KONTROLÜ ---
  bool _puanVerildi = false; // Aynı zombiden defalarca puan almamak için

  Dusman({super.position, super.size}) : super(anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    super.onLoad();

    final kareler = <Sprite>[];
    for (var i = 1; i <= 8; i++) {
      kareler.add(await gameRef.loadSprite('dusman/Attack ($i).png'));
    }
    
    animation = SpriteAnimation.spriteList(kareler, stepTime: 0.1, loop: true);

    add(RectangleHitbox(
      size: Vector2(size.x * 0.5, size.y * 0.7),
      position: Vector2(size.x * 0.25, size.y * 0.15),
      collisionType: CollisionType.passive,
    ));
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= _hareketHizi * dt;

    // --- YENİ: SKOR HESAPLAMA ---
    // Eğer zombi karakterin soluna geçtiyse ve henüz puan verilmediyse
    if (!_puanVerildi && position.x < gameRef.oyuncu.position.x) {
      _puanVerildi = true;
      gameRef.skor += 10; // 10 puan ekle
    }

    if (position.x < -size.x) {
      removeFromParent();
    }
  }
}