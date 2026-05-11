
<?php
include "db.php";


//Silme İşlemi
if(isset($_GET["sil"])) {

    $id=$_GET["sil"];//Otobüs id si 

    $silSQL="DELETE FROM otobusler WHERE otobus_id=$id";

    mysqli_query($baglanti,$silSQL);

    header("Location:index.php");

    exit;


}




$sql="SELECT  otobusler.otobus_id, 
              otobusler.plaka,  
              guzergah.baslangic,
              guzergah.bitis,
              guzergah.sure,
              soforler.ad_soyad,
              soforler.telefon
     FROM otobusler 
     INNER JOIN guzergah  ON otobusler.guzergah_id=guzergah.guzergah_id
     INNER JOIN soforler  ON otobusler.sofor_id=soforler.sofor_id      

"; //otobüsler tablosundaki guzergah_il ile guzergah tablosundaki guzergah_id aynı olanları birleştir.

$sonuc=mysqli_query($baglanti,$sql);




?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>OTOBÜS YÖNETİM SİSTEMİ</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
   <?php include 'header.php' ?>
    <section class="ana">
        <h3>OTOBÜS BİLGİLERİ</h3>
        <table>
            <tr>
                <th>Sıra No</th>
                <th>Plaka</th>
                <th>Güzergah</th>
                <th>Tahmini Süre</th>
                <th>Şoför Ad Soyad</th>
                <th>Telefon</th>
                <th>İşlemler</th>
            </tr>
            <?php 
                //Telefon Format 
                function telefonFormat($tel) {
                       return substr($tel,0,4)." ".
                              substr($tel,4,3)." ".
                              substr($tel,7,2)." ".
                              substr($tel, 9,2); 


                }
            
            
            
            ?>
           <?php $sira=0; ?>
           <?php while($dizi=mysqli_fetch_assoc($sonuc)) { $sira++;?>
            <tr>
                <td><?php echo $sira;?></td>
                <td class="plaka"><?php echo $dizi["plaka"] ;?></td>
                  <td><?php echo $dizi["baslangic"]."-".$dizi["bitis"];?></td>
                  <td><?php echo $dizi["sure"]." dk" ;?></td>
                    <td><?php echo $dizi["ad_soyad"] ;?></td>
                      <td><?php echo telefonFormat($dizi["telefon"] );?></td>
                      <td>
                        <a href="">✍️</a>
                        <a href="index.php?sil=<?php echo $dizi["otobus_id"] ?>" onclick="return confirm('Bu otobüs verisini silmek istediğinden emin misiniz?')">🗑️</a>

                      </td> 
            </tr>
            
            <?php } ?>

            
        </table>
       
          
    </section>
</body>
</html>