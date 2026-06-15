import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OgrenciSayfasi extends StatefulWidget {
  const OgrenciSayfasi({super.key});

  @override
  State<OgrenciSayfasi> createState() => _OgrenciSayfasiState();
}

class _OgrenciSayfasiState extends State<OgrenciSayfasi> {
  // TextField alanlarindaki verileri almak icin kullanilir.
  final TextEditingController adController = TextEditingController();
  final TextEditingController sinifController = TextEditingController();
  final TextEditingController numaraController = TextEditingController();

  /*
    FirebaseFirestore.instance:
    Uygulamanin bagli oldugu Firestore veritabanina ulasir.

    collection('ogrenciler'):
    Firestore icindeki ogrenciler koleksiyonunu temsil eder.

    Bu degiskeni tekrar tekrar uzun kod yazmamak icin olusturduk.
  */
  final CollectionReference ogrenciler =
      FirebaseFirestore.instance.collection('ogrenciler');

  bool islemYapiliyor = false;

  // CREATE - YENI OGRENCI EKLEME
  Future<void> ogrenciEkle() async {
    final String ad = adController.text.trim();
    final String sinif = sinifController.text.trim();
    final int? numara = int.tryParse(
      numaraController.text.trim(),
    );

    // Form alanlari bos birakilirsa kayit yapma.
    if (ad.isEmpty || sinif.isEmpty || numara == null) {
      mesajGoster('Lutfen bilgileri eksiksiz giriniz.');
      return;
    }

    try {
      setState(() {
        islemYapiliyor = true;
      });

      /*
        add() metodu:
        ogrenciler koleksiyonuna yeni bir belge ekler.

        Firebase belge kimligini otomatik olarak olusturur.

        Olusacak yapi:

        ogrenciler
          └── rastgeleBelgeId
                ├── ad
                ├── sinif
                └── numara
      */
      await ogrenciler.add({
        'ad': ad,
        'sinif': sinif,
        'numara': numara,

        // Kayit tarihini kullanicinin telefonuna gore degil,
        // Firebase sunucusunun saatine gore kaydeder.
        'kayitTarihi': FieldValue.serverTimestamp(),
      });

      alanlariTemizle();

      mesajGoster('Ogrenci basariyla eklendi.');
    } on FirebaseException catch (hata) {
      mesajGoster('Firebase hatasi: ${hata.message}');
    } catch (hata) {
      mesajGoster('Beklenmeyen hata: $hata');
    } finally {
      if (mounted) {
        setState(() {
          islemYapiliyor = false;
        });
      }
    }
  }

  // UPDATE - OGRENCI GUNCELLEME
  Future<void> ogrenciGuncelle({
    required String belgeId,
    required String ad,
    required String sinif,
    required int numara,
  }) async {
    try {
      /*
        doc(belgeId):
        Guncellenecek belgeyi belge kimligiyle bulur.

        update():
        Sadece belirtilen alanlari gunceller.
        Belgenin diger alanlari korunur.
      */
      await ogrenciler.doc(belgeId).update({
        'ad': ad,
        'sinif': sinif,
        'numara': numara,
      });

      mesajGoster('Ogrenci bilgileri guncellendi.');
    } on FirebaseException catch (hata) {
      mesajGoster('Guncelleme hatasi: ${hata.message}');
    } catch (hata) {
      mesajGoster('Beklenmeyen hata: $hata');
    }
  }

  // DELETE - OGRENCI SILME
  Future<void> ogrenciSil(String belgeId) async {
    try {
      /*
        doc(belgeId):
        Silinecek ogrenci belgesini bulur.

        delete():
        Belgeyi Firestore veritabanindan tamamen siler.
      */
      await ogrenciler.doc(belgeId).delete();

      mesajGoster('Ogrenci silindi.');
    } on FirebaseException catch (hata) {
      mesajGoster('Silme hatasi: ${hata.message}');
    } catch (hata) {
      mesajGoster('Beklenmeyen hata: $hata');
    }
  }

  // GUNCELLEME PENCERESINI ACAR
  void guncellemePenceresiAc({
    required String belgeId,
    required String mevcutAd,
    required String mevcutSinif,
    required int mevcutNumara,
  }) {
    final TextEditingController guncelAdController =
        TextEditingController(text: mevcutAd);

    final TextEditingController guncelSinifController =
        TextEditingController(text: mevcutSinif);

    final TextEditingController guncelNumaraController =
        TextEditingController(
      text: mevcutNumara.toString(),
    );

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Ogrenci Guncelle'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: guncelAdController,
                  decoration: const InputDecoration(
                    labelText: 'Ad',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: guncelSinifController,
                  decoration: const InputDecoration(
                    labelText: 'Sinif',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: guncelNumaraController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Numara',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Iptal'),
            ),
            ElevatedButton(
              onPressed: () async {
                final String yeniAd =
                    guncelAdController.text.trim();

                final String yeniSinif =
                    guncelSinifController.text.trim();

                final int? yeniNumara = int.tryParse(
                  guncelNumaraController.text.trim(),
                );

                if (yeniAd.isEmpty ||
                    yeniSinif.isEmpty ||
                    yeniNumara == null) {
                  mesajGoster('Bilgileri kontrol ediniz.');
                  return;
                }

                await ogrenciGuncelle(
                  belgeId: belgeId,
                  ad: yeniAd,
                  sinif: yeniSinif,
                  numara: yeniNumara,
                );

                if (dialogContext.mounted) {
                  Navigator.pop(dialogContext);
                }
              },
              child: const Text('Guncelle'),
            ),
          ],
        );
      },
    );
  }

  // SILME ONAY PENCERESI
  void silmeOnayiGoster(String belgeId, String ad) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Ogrenciyi Sil'),
          content: Text('$ad isimli ogrenci silinsin mi?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Iptal'),
            ),
            ElevatedButton(
              onPressed: () async {
                await ogrenciSil(belgeId);

                if (dialogContext.mounted) {
                  Navigator.pop(dialogContext);
                }
              },
              child: const Text('Sil'),
            ),
          ],
        );
      },
    );
  }

  void alanlariTemizle() {
    adController.clear();
    sinifController.clear();
    numaraController.clear();
  }

  void mesajGoster(String mesaj) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mesaj),
      ),
    );
  }

  @override
  void dispose() {
    // Controller nesnelerini sayfa kapanirken bellekten temizler.
    adController.dispose();
    sinifController.dispose();
    numaraController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ogrenci CRUD'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // OGRENCI EKLEME FORMU
            TextField(
              controller: adController,
              decoration: const InputDecoration(
                labelText: 'Ogrenci adi',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: sinifController,
              decoration: const InputDecoration(
                labelText: 'Sinifi',
                prefixIcon: Icon(Icons.school),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: numaraController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Numarasi',
                prefixIcon: Icon(Icons.numbers),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: islemYapiliyor ? null : ogrenciEkle,
                icon: const Icon(Icons.add),
                label: Text(
                  islemYapiliyor
                      ? 'Kaydediliyor...'
                      : 'Ogrenci Ekle',
                ),
              ),
            ),
            const SizedBox(height: 20),

            // READ - OGRENCILERI FIREBASE'DEN OKUMA
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                /*
                  snapshots():
                  ogrenciler koleksiyonunu gercek zamanli olarak dinler.

                  Firebase'de ekleme, silme veya guncelleme olursa
                  StreamBuilder yeniden calisir ve ekran yenilenir.

                  orderBy('numara'):
                  Ogrencileri numara alanina gore siralar.
                */
                stream: ogrenciler
                    .orderBy('numara')
                    .snapshots(),
                builder: (context, snapshot) {
                  // Firebase verileri alinirken yukleme gostergesi.
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  // Firestore okuma hatasi olursa.
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Veriler alinamadi:\n${snapshot.error}',
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  /*
                    snapshot.data!.docs:
                    ogrenciler koleksiyonundaki tum belgeleri verir.
                  */
                  final List<QueryDocumentSnapshot> belgeler =
                      snapshot.data!.docs;

                  if (belgeler.isEmpty) {
                    return const Center(
                      child: Text(
                        'Henuz ogrenci eklenmedi.',
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: belgeler.length,
                    itemBuilder: (context, index) {
                      /*
                        belge:
                        Firestore'daki tek bir ogrenci belgesidir.

                        belge.id:
                        Firebase'in otomatik olusturdugu belge kimligidir.

                        belge.data():
                        Belgenin icindeki ad, sinif ve numara alanlarini verir.
                      */
                      final QueryDocumentSnapshot belge =
                          belgeler[index];

                      final Map<String, dynamic> veri =
                          belge.data()
                              as Map<String, dynamic>;

                      final String ad =
                          veri['ad']?.toString() ?? '';

                      final String sinif =
                          veri['sinif']?.toString() ?? '';

                      final int numara =
                          (veri['numara'] as num?)?.toInt() ?? 0;

                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(
                              numara.toString(),
                            ),
                          ),
                          title: Text(ad),
                          subtitle: Text('Sinif: $sinif'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                tooltip: 'Guncelle',
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  guncellemePenceresiAc(
                                    belgeId: belge.id,
                                    mevcutAd: ad,
                                    mevcutSinif: sinif,
                                    mevcutNumara: numara,
                                  );
                                },
                              ),
                              IconButton(
                                tooltip: 'Sil',
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  silmeOnayiGoster(
                                    belge.id,
                                    ad,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}