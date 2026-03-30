import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'oyun.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: GameWidget<BenimOyunum>(
          game: BenimOyunum(),
          // --- YENİ: OYUN BİTTİ ARAYÜZÜ (OVERLAY) ---
          overlayBuilderMap: {
            'OyunBittiMenu': (context, game) {
              return Center(
                child: Container(
                  width: 300,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(200),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'OYUN BİTTİ',
                        style: TextStyle(color: Colors.red, fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Skorun: ${game.skor}',
                        style: const TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => game.oyunuSifirla(), // Oyunu sıfırlayan butonu tetikle
                        child: const Text('TEKRAR DENE'),
                      ),
                    ],
                  ),
                ),
              );
            },
          },
        ),
      ),
    ),
  );
}