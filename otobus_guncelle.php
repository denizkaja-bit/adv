
<?php
include "includes/db.php";


$id=$_GET['gun'];  

//Form gönderildiyse kayıt İşlemi gerçekleşsin

if(isset($_POST["kaydet"])){

//Formdan gelen veriler alınır

$plaka=$_POST["plaka"];
$guzergah_id=$_POST["guzergah_id"];
$sofor_id=$_POST["sofor_id"];

//otobüsler tablosuna güncelleme

$sqlGuncelle="UPDATE otobusler SET plaka='$plaka',guzergah_id='$guzergah_id',sofor_id='$sofor_id' WHERE otobus_id='$id'";

//SQL komutunu sorguluyoruz ve çalıştırıyoruz
mysqli_query($baglanti, $sqlGuncelle);

//Kayıttan sonra anasayfaya dön
 header("Location:index.php");

 exit();



}



//SELECT menüler için standart VErileri Çekme

$sql1="SELECT * FROM guzergah";
$sql2= "SELECT * FROM soforler";

$sonuc1=mysqli_query($baglanti,$sql1);
$sonuc2=mysqli_query($baglanti,$sql2);



//Güncellenecek otobüsün mevcut verilerini çek
$sqlotobus="SELECT * FROM otobusler  WHERE otobus_id='$id'";
$sorgu=mysqli_query($baglanti,$sqlotobus);

$otobus=mysqli_fetch_assoc($sorgu);



?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>OTOBÜS YÖNETİM SİSTEMİ</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/form.css">
</head>
<body>
   <?php include 'includes/header.php' ?>
    <section class="ana">
        <h3>OTOBÜS EKLE </h3>
        
       <form action="" method="post">


       <input type="text" name="plaka" placeholder="Plaka" required value="<?php echo $otobus['plaka']?>">
      
  
       <select name="guzergah_id" id="" required class="sec" >
                <?php  while ($dizi=mysqli_fetch_assoc($sonuc1)) { ?>
                            <option value="<?php echo $dizi["guzergah_id"]   ?>"  <?php if ($dizi["guzergah_id"] == $otobus["guzergah_id"]) echo "selected"; ?>> <?php  echo $dizi["baslangic"]."-".$dizi["bitis"]?></option>
       
                <?php } ?>
       </select>


       <select name="sofor_id" id="" required class="sec">
                <?php  while ($dizi=mysqli_fetch_assoc($sonuc2)) { ?>
                            <option value="<?php echo $dizi["sofor_id"]  ?>"<?php if($dizi["sofor_id"]==$otobus["sofor_id"]) echo "selected" ?>> <?php  echo $dizi["ad_soyad"]?></option>
       
                <?php } ?>
       </select>

       <button type="submit" name="kaydet">Kaydet</button>
       <button type="reset">Temizle</button>
       </form>
       
          
    </section>
    <?php include "modal/modal.php" ?>
    <script src="modal/modal.js"></script>
</body>
</html>