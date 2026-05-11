
<?php
include "db.php";

if(isset($_GET["sil"])) {

$id=$_GET["sil"];

//Bu güzergaha bağlı otobüs var mı?

$kontrolSQL="SELECT * from otobusler WHERE guzergah_id=$id";
$kontrolSonuc=mysqli_query($baglanti,$kontrolSQL);

//Hata Mesajı
if(mysqli_num_rows($kontrolSonuc)>0){

                echo "
                <script>
                    alert('Bu güzergah başka bir otobüs tarafından kullanılıyor.');

                    window.location.href='guzergah.php';

                </script>";
 

}

else {


$silSQL="DELETE FROM guzergah WHERE guzergah_id=$id ";

mysqli_query($baglanti,$silSQL);


header("Location:guzergah.php");


exit;
}

}


$sql="SELECT * FROM guzergah";
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
        <h3>GÜZERGAH BİLGİLERİ</h3>
        <table>
            <tr>
                <th>Sıra No</th>
                <th>Başlangıç</th>
                <th>Bitiş</th>
                <th>Tahmini Süre</th>
                <th>İşlemler</th>
             
            </tr>
           
           <?php $sira=0; ?>
           <?php while($dizi=mysqli_fetch_assoc($sonuc)) { $sira++;?>
            <tr class="guzergahtr">
                <td><?php echo $sira;?></td>
                <td ><?php echo $dizi["baslangic"] ;?></td>
                  <td><?php echo $dizi["bitis"];?></td>
                  <td><?php echo $dizi["sure"]." dk" ;?></td>
                  <td>
                       <a href="">✍️</a>
                        <a href="guzergah.php?sil=<?php echo $dizi["guzergah_id"] ?>" onclick="return confirm('Bu güzergah verisini silmek istediğinden emin misiniz?')">🗑️</a>
                    

                  </td> 
                  

            </tr>
            
            <?php } ?>

            
        </table>
       
          
    </section>
   
</body>
</html>