import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame/parallax.dart'; 
import 'package:flame/events.dart';
import 'package:flutter/material.dart'; 
import 'karakter.dart';
import 'dusman.dart';

class BenimOyunum extends FlameGame with TapCallbacks, HasCollisionDetection {
  late Karakter oyuncu; // Diğer dosyalardan erişim için 'late' ve 'public' yaptık
  late final JoystickComponent _joystick;
  late final ParallaxComponent _arkaPlan;
  late final HudButtonComponent _ziplamaAlani;
  late Timer _zombiOlusturucu;

  // --- YENİ EKLENEN SKOR VE CAN DEĞİŞKENLERİ ---
  int skor = 0; // Oyun puanını tutar
  late TextComponent skorMetni; // Ekranda skoru gösteren yazı bileşeni
  late TextComponent canMetni;  // Ekranda canı gösteren yazı bileşeni

  @override
  Future<void> onLoad() async {
    super.onLoad();

    _arkaPlan = await loadParallaxComponent(
      [ParallaxImageData('arkaplan.png')],
      baseVelocity: Vector2(0, 0),
    );
    await add(_arkaPlan);

    // --- YENİ: SKOR METNİ TASARIMI (Sol Üst) ---
    skorMetni = TextComponent(
      text: 'Skor: 0',
      position: Vector2(20, 20), // Sol üst köşe
      textRenderer: TextPaint(
        style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
    add(skorMetni);

    // --- YENİ: CAN METNİ TASARIMI (Sağ Üst) ---
    canMetni = TextComponent(
      text: 'Can: 3',
      position: Vector2(size.x - 130, 20), // Sağ üst köşe
      textRenderer: TextPaint(
        style: const TextStyle(color: Colors.redAccent, fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
    add(canMetni);

    _joystick = JoystickComponent(
      knob: CircleComponent(radius: 20, paint: Paint()..color = Colors.white.withAlpha(200)),
      background: CircleComponent(radius: 50, paint: Paint()..color = Colors.lightBlue.withAlpha(180)),
      margin: const EdgeInsets.only(left: 40, bottom: 40),
    );

    oyuncu = Karakter(
      position: Vector2(size.x * 0.2, size.y * 0.8),
      size: Vector2(100, 100),
    );

    _ziplamaAlani = HudButtonComponent(
      button: CircleComponent(radius: 40, paint: Paint()..color = Colors.lightGreenAccent.withAlpha(150)),
      margin: const EdgeInsets.only(right: 60, bottom: 60),
      onPressed: () => oyuncu.zipla(),
    );

    _zombiOlusturucu = Timer(3, repeat: true, onTick: () => _dusmanEkle());

    await add(oyuncu);
    add(_joystick);
    add(_ziplamaAlani);
  }

  void _dusmanEkle() {
    final zombi = Dusman(
      position: Vector2(size.x + 100, size.y * 0.8),
      size: Vector2(110, 110),
    );
    zombi.flipHorizontallyAroundCenter();
    add(zombi);
  }

  // --- YENİ: OYUNU SIFIRLAMA FONKSİYONU ---
  void oyunuSifirla() {
    skor = 0; // Skoru sıfırla
    oyuncu.can = 3; // Canı doldur
    oyuncu.position = Vector2(size.x * 0.2, size.y * 0.8); // Karakteri başlangıca çek
    children.whereType<Dusman>().forEach((d) => d.removeFromParent()); // Ekrandaki zombileri sil
    overlays.remove('OyunBittiMenu'); // Menüyü kapat
    resumeEngine(); // Oyunu devam ettir
  }

  @override
  void update(double dt) {
    if (paused) return; 

    super.update(dt);
    _zombiOlusturucu.update(dt);

    // --- YENİ: METİNLERİ HER KAREDE GÜNCELLE ---
    skorMetni.text = 'Skor: $skor';
    canMetni.text = 'Can: ${oyuncu.can}';

    if (!_joystick.delta.isZero()) {
      _arkaPlan.parallax?.baseVelocity.x = _joystick.relativeDelta.x * 50;
      oyuncu.position.x += _joystick.relativeDelta.x * 300 * dt;
      
      if (oyuncu.current != KarakterDurumu.ziplama) {
        oyuncu.current = (_joystick.relativeDelta.length > 0.8) 
            ? KarakterDurumu.kosma 
            : KarakterDurumu.yurume;
      }

      if (_joystick.relativeDelta.x < 0 && oyuncu.scale.x > 0) {
        oyuncu.flipHorizontallyAroundCenter();
      } else if (_joystick.relativeDelta.x > 0 && oyuncu.scale.x < 0) {
        oyuncu.flipHorizontallyAroundCenter();
      }
    } else {
      _arkaPlan.parallax?.baseVelocity.x = 0;
      if (oyuncu.current != KarakterDurumu.ziplama) {
        oyuncu.current = KarakterDurumu.bekleme;
      }
    }
  }
}