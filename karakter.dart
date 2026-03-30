import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/collisions.dart'; // Çarpışma kutuları için gerekli
import 'dusman.dart'; // Zombileri tanımak için
import 'oyun.dart'; // Oyun skoruna ve durdurma komutuna erişmek için

// Karakterin hareket durumları
enum KarakterDurumu { bekleme, yurume, kosma, ziplama }

class Karakter extends SpriteAnimationGroupComponent<KarakterDurumu> with HasGameRef<BenimOyunum>, CollisionCallbacks {
  // FİZİK DEĞİŞKENLERİ
  final double _yercekimi = 1000;
  final double _ziplamaGucu = -800;
  double _dikeyHiz = 0;
  bool _yerdeMi = true;

  // --- YENİ EKLENEN CAN VE DURUM SİSTEMİ ---
  int can = 3; // Karakterin toplam 3 canı var
  bool _hasarAlabilirMi = true; // Hasar aldıktan sonra 1 saniye koruma sağlar (sürekli can gitmesini engeller)

  Karakter({super.position, super.size, super.anchor = Anchor.center});

  @override
  Future<void> onLoad() async {
    super.onLoad();
    priority = 10;

    // --- HITBOX AYARI ---
    // Karakterin çarpışma kutusunu ekliyoruz. 
    // Not: Zombinin hitbox'ını 'dusman.dart' içinde daralttığımız için 
    // artık sadece zombinin gövdesine değince canın gidecek.
    add(RectangleHitbox());

    // Animasyonları yükle
    final beklemeAnim = await _animasyonOlustur('Idle', 16, 0.08);
    final yurumeAnim = await _animasyonOlustur('Walk', 20, 0.06);
    final kosmaAnim = await _animasyonOlustur('Run', 20, 0.05);
    final ziplamaAnim = await _animasyonOlustur('Jump', 1, 0.1);

    animations = {
      KarakterDurumu.bekleme: beklemeAnim,
      KarakterDurumu.yurume: yurumeAnim,
      KarakterDurumu.kosma: kosmaAnim,
      KarakterDurumu.ziplama: ziplamaAnim,
    };

    current = KarakterDurumu.bekleme;
  }

  // --- ÇARPIŞMA BAŞLADIĞINDA ÇALIŞAN KOMUT ---
  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    // Eğer çarpan şey bir zombiyse (Dusman) ve karakter şu an hasar alabilir durumdaysa
    if (other is Dusman && _hasarAlabilirMi) {
      _hasarAlabilirMi = false; // Geçici olarak ölümsüz yap
      can--; // Canı bir azalt
      
      print("Zombi çarptı! Kalan Can: $can");

      // Can tamamen bittiyse oyunu durdur ve menüyü göster
      if (can <= 0) {
        gameRef.pauseEngine(); // Oyun motorunu durdurur
        gameRef.overlays.add('OyunBittiMenu'); // 'main.dart' içindeki menüyü açar
      }

      // Hasar aldıktan 1 saniye sonra tekrar hasar alabilir hale getir
      // Bu sayede zombinin içinden geçerken 3 can birden gitmez
      Future.delayed(const Duration(seconds: 1), () {
        _hasarAlabilirMi = true;
      });
    }
  }

  // Animasyonları dosyalardan çeken yardımcı fonksiyon
  Future<SpriteAnimation> _animasyonOlustur(String dosyaAdi, int kareSayisi, double hiz) async {
    final kareler = <Sprite>[];
    for (var i = 1; i <= kareSayisi; i++) {
      kareler.add(await gameRef.loadSprite('karakter/$dosyaAdi ($i).png'));
    }
    return SpriteAnimation.spriteList(kareler, stepTime: hiz);
  }

  // Zıplama komutu
  void zipla() {
    if (_yerdeMi) {
      _dikeyHiz = _ziplamaGucu;
      _yerdeMi = false;
      current = KarakterDurumu.ziplama;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Yerçekimi hesabı
    if (!_yerdeMi) {
      _dikeyHiz += _yercekimi * dt;
      position.y += _dikeyHiz * dt;
    }

    // Karakterin basacağı zemin seviyesi
    final yolSeviyesi = gameRef.size.y * 0.8;
    if (position.y >= yolSeviyesi) {
      position.y = yolSeviyesi;
      _dikeyHiz = 0;
      _yerdeMi = true;
      if (current == KarakterDurumu.ziplama) current = KarakterDurumu.bekleme;
    }
  }
}