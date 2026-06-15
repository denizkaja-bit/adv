// Cloud Firestore veritabanini kullanabilmek icin gerekli paket.
// FirebaseFirestore, QuerySnapshot, DocumentSnapshot gibi
// Firebase siniflari bu paketten gelir.
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class OgrenciSayfasi extends StatefulWidget {
  const OgrenciSayfasi({super.key});

  @override
  State<OgrenciSayfasi> createState() => _OgrenciSayfasiState();
}

class _OgrenciSayfasiState extends State<OgrenciSayfasi> {
  /*
    TextEditingController nesneleri, TextField alanlarina
    yazilan bilgileri okumamizi saglar.

    Ornegin:
    adController.text

    ifadesi, ogrenci adi alanina yazilan metni getirir.
  */
  final adController = TextEditingController();
  final sinifController = TextEditingController();
  final numaraController = TextEditingController();

  /*
    FirebaseFirestore.instance

    Flutter uygulamasinin bagli oldugu
    Cloud Firestore veritabanina ulasir.

    Bunun calisabilmesi icin Firebase'in main.dart
    dosyasinda daha once baslatilmis olmasi gerekir:

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  */

  /*
    collection('ogrenciler')

    Firestore veritabanindaki "ogrenciler"
    isimli koleksiyonu secer.

    Firestore yapisi su sekildedir:

    ogrenciler                   → koleksiyon
        └── rastgeleBelgeId      → belge
              ├── ad
              ├── sinif
              └── numara

    Burada ogrenciler degiskeni artik Firebase'deki
    ogrenciler koleksiyonunu temsil eder.
  */
  final CollectionReference<Map<String, dynamic>> ogrenciler =
      FirebaseFirestore.instance.collection('ogrenciler');

  /*
    CREATE ISLEMI

    Yeni bir ogrenciyi Firestore veritabanina ekler.

    Future<void>:
    Bu fonksiyonun internet uzerinden gerceklestirilen
    zaman alan bir islem yaptigini belirtir.

    async:
    Fonksiyonun icinde await kullanmamizi saglar.
  */
  Future<void> ogrenciEkle() async {
    /*
      TextField alanlarina girilen bilgiler alinir.
    */
    String ad = adController.text;
    String sinif = sinifController.text;

    /*
      TextField veriyi metin olarak verir.

      Ogrenci numarasi Firestore'a number turunde
      kaydedilecegi icin int turune donusturulur.
    */
    int numara = int.parse(numaraController.text);

    /*
      ogrenciler.add({...})

      ogrenciler koleksiyonuna yeni bir belge ekler.

      add() kullanildiginda belge kimligini Firebase
      otomatik olarak olusturur.

      Ornegin:

      ogrenciler
          └── aB7xQp92LmK5...
                ├── ad: "Ahmet"
                ├── sinif: "10/A"
                └── numara: 125

      Buradaki aB7xQp92LmK5... degeri Firebase'in
      otomatik olusturdugu belge kimligidir.
    */

    /*
      await:

      Firebase'e veri ekleme islemi tamamlanana kadar
      bir sonraki satira gecilmemesini saglar.
    */
    await ogrenciler.add({
      /*
        Sol taraftaki ad, sinif ve numara ifadeleri
        Firestore'daki alan adlaridir.

        Sag taraftaki degiskenler ise TextField
        alanlarindan aldigimiz degerlerdir.
      */
      'ad': ad,
      'sinif': sinif,
      'numara': numara,
    });

    /*
      Firebase'e ekleme islemi tamamlandiktan sonra
      TextField alanlari temizlenir.
    */
    adController.clear();
    sinifController.clear();
    numaraController.clear();
  }

  /*
    DELETE ISLEMI

    Firestore'daki bir ogrenci belgesini siler.

    Silme islemi icin ogrencinin adini veya numarasini
    degil, Firebase belge kimligini kullaniriz.
  */
  Future<void> ogrenciSil(String belgeId) async {
    /*
      doc(belgeId)

      ogrenciler koleksiyonu icinden belge kimligi
      verilen belgeyi secer.

      Ornegin:

      ogrenciler.doc('aB7xQp92LmK5')
    */

    /*
      delete()

      Secilen belgeyi Firestore veritabanindan siler.
    */

    /*
      await:

      Silme islemi tamamlanana kadar bekler.
    */
    await ogrenciler.doc(belgeId).delete();
  }

  @override
  void dispose() {
    /*
      Sayfa kapatildiginda controller nesneleri
      bellekten temizlenir.
    */
    adController.dispose();
    sinifController.dispose();
    numaraController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ogrenci Firebase'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /*
              OGRENCI ADI GIRIS ALANI
            */
            TextField(
              controller: adController,
              decoration: const InputDecoration(
                labelText: 'Ogrenci adi',
              ),
            ),

            /*
              OGRENCI SINIFI GIRIS ALANI
            */
            TextField(
              controller: sinifController,
              decoration: const InputDecoration(
                labelText: 'Sinifi',
              ),
            ),

            /*
              OGRENCI NUMARASI GIRIS ALANI

              keyboardType:
              Telefonda sayisal klavyenin acilmasini saglar.
            */
            TextField(
              controller: numaraController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Numarasi',
              ),
            ),

            const SizedBox(height: 10),

            /*
              Butona basildiginda ogrenciEkle()
              fonksiyonu calisir.

              Bu fonksiyon girilen bilgileri
              Firestore'a kaydeder.
            */
            ElevatedButton(
              onPressed: ogrenciEkle,
              child: const Text('Ogrenci Ekle'),
            ),

            const Divider(),

            /*
              READ ISLEMI

              Firestore'daki ogrencileri okuyup
              ekranda listeleyecegiz.
            */
            Expanded(
              /*
                StreamBuilder:

                Firebase'den gelen gercek zamanli verileri
                dinlemek ve ekranda gostermek icin kullanilir.

                Firestore'da veri eklenirse, silinirse veya
                degistirilirse StreamBuilder yeniden calisir.

                Bu nedenle manuel olarak setState()
                kullanmamiza gerek kalmaz.
              */
              child: StreamBuilder<
                  QuerySnapshot<Map<String, dynamic>>>(
                /*
                  ogrenciler.snapshots()

                  Firestore'daki ogrenciler koleksiyonunu
                  gercek zamanli olarak dinler.

                  snapshots() bize bir Stream verir.

                  Stream:
                  Zaman icinde veri gondermeye devam eden
                  bir veri akisidir.
                */
                stream: ogrenciler.snapshots(),

                /*
                  builder:

                  Firebase'den her yeni veri geldiginde
                  bu bolum yeniden calisir.

                  context:
                  Widget agacindaki konumu temsil eder.

                  snapshot:
                  Firebase'den gelen veriyi ve islemin
                  durumunu tasir.
                */
                builder: (context, snapshot) {
                  /*
                    snapshot.hasData:

                    Firebase'den veri gelip gelmedigini
                    kontrol eder.

                    Veri henuz gelmediyse ekranda
                    yukleme simgesi gosterilir.
                  */
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  /*
                    snapshot.data:

                    Firestore'dan gelen QuerySnapshot
                    nesnesidir.

                    docs:

                    Koleksiyonun icindeki tum belgeleri
                    liste halinde verir.
                  */
                  final belgeler = snapshot.data!.docs;

                  /*
                    ListView.builder:

                    Firestore'daki belge sayisi kadar
                    liste elemani olusturur.
                  */
                  return ListView.builder(
                    /*
                      Firestore'dan kac belge geldiyse
                      o kadar ListTile olusturulur.
                    */
                    itemCount: belgeler.length,

                    itemBuilder: (context, index) {
                      /*
                        Belgeler listesinden siradaki
                        Firebase belgesi alinir.

                        belge degiskeni tek bir ogrenci
                        belgesini temsil eder.
                      */
                      final belge = belgeler[index];

                      /*
                        belge.data():

                        Firestore belgesinin icindeki
                        alanlari getirir.

                        Ornegin:

                        {
                          'ad': 'Ahmet',
                          'sinif': '10/A',
                          'numara': 125
                        }

                        Veri Map yapisinda gelir.
                      */
                      final Map<String, dynamic> veri =
                          belge.data();

                      /*
                        Firestore'daki alanlara
                        anahtar isimleriyle ulasilir.

                        veri['ad']
                        veri['sinif']
                        veri['numara']
                      */
                      return ListTile(
                        /*
                          Firestore'daki ad alani
                          ekranda baslik olarak gosterilir.
                        */
                        title: Text(
                          veri['ad'].toString(),
                        ),

                        /*
                          Sinif ve numara bilgileri
                          alt yazi olarak gosterilir.
                        */
                        subtitle: Text(
                          '${veri['sinif']} - ${veri['numara']}',
                        ),

                        /*
                          Her ogrenci satirinin saginda
                          silme butonu bulunur.
                        */
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),

                          onPressed: () {
                            /*
                              belge.id:

                              Firebase'in bu belge icin
                              olusturdugu benzersiz kimliktir.

                              ogrenciSil() fonksiyonuna bu
                              kimligi gonderiyoruz.

                              Boylece hangi belgenin
                              silinecegi belirlenir.
                            */
                            ogrenciSil(belge.id);
                          },
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