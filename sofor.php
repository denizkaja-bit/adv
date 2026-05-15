
<?php
include "db.php";

if(isset($_GET["sil"])) {
$id=$_GET["sil"];

//Bu güzergaha bağlı otobüs var mı?

$kontrolSQL="SELECT * from otobusler WHERE sofor_id=$id";
$kontrolSonuc=mysqli_query($baglanti,$kontrolSQL);


if(mysqli_num_rows($kontrolSonuc)>0){

echo "<script>alert('Bu şöfor başka bir otobüs tarafından kullanılıyor.');</script>";

}

else {

$silSQL="DELETE FROM guzergah WHERE sofor_id=$id ";
mysqli_query($baglanti,$silSQL);
header("Location:sofor.php");
exit;

}
}

$sql="SELECT * FROM soforler";
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
        <h3>ŞOFÖR BİLGİLERİ</h3>
        <table>
            <tr>
                <th>Sıra No</th>
                <th>As Soyad</th>
                <th>Yaş</th>
                <th>Telefon</th>
                <th>İşlemler</th>
             
            </tr>
           
           <?php $sira=0; ?>
            <?php 
                function telefonFormat($tel) {
                       return substr($tel,0,4)." ".
                              substr($tel,4,3)." ".
                              substr($tel,7,2)." ".
                              substr($tel, 9,2); 


                }
            
            
            
            ?>
           <?php while($dizi=mysqli_fetch_assoc($sonuc)) { $sira++;?>
            <tr class="guzergahtr">
                <td><?php echo $sira;?></td>
                <td ><?php echo $dizi["ad_soyad"] ;?></td>
                  <td><?php echo $dizi["yas"];?></td>
                  <td><?php echo telefonFormat($dizi["telefon"] );?></td>
                   <td>
                       <a href="">✍️</a>
                        <a href="sofor.php?sil=<?php echo $dizi["sofor_id"] ?>" onclick="return confirm('Bu şoför verisini silmek istediğinden emin misiniz?')">🗑️</a>
                   </td>
                  

            </tr>
            
            <?php } ?>

            
        </table>
       
          
    </section>
</body>
</html>