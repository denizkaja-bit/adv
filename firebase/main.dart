import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'ogrenci_sayfasiIleri.dart';

Future<void> main() async {
  // Firebase baslatilmadan once Flutter altyapisini hazirlar.
  WidgetsFlutterBinding.ensureInitialized();

  // Flutter projesini firebase_options.dart dosyasindaki
  // bilgilerle Firebase projesine baglar.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ogrenci Firebase CRUD',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: const OgrenciSayfasi(),
    );
  }
}