
<?php
include "db.php";

if(isset($_GET["sil"])) {

$id=$_GET["sil"];

//Bu güzergaha bağlı otobüs var mı?

$kontrolSQL="SELECT * from otobusler WHERE guzergah_id=$id";
$kontrolSonuc=mysqli_query($baglanti,$kontrolSQL);

//Hata Mesajı
if(mysqli_num_rows($kontrolSonuc)>0){

                // echo "
                // <script>
                //     alert('Bu güzergah başka bir otobüs tarafından kullanılıyor.');

                //     window.location.href='guzergah.php';

                // </script>";
    header("Location:hata.php?mesaj=guzergah_kullanimda");
    exit;


}

else {


$silSQL="DELETE FROM guzergah WHERE guzergah_id=$id ";

mysqli_query($baglanti,$silSQL);


header("Location:guzergah.php");


exit;
}

}


// $sql="SELECT * FROM guzergah";
// $sonuc=mysqli_query($baglanti,$sql);
//Sıralama kodu
// $sql = "SELECT * FROM guzergah"; Arama kodu gelince güncelleştir

//Arama kodu
$sql = "SELECT * FROM guzergah WHERE 1=1";  //Sonradan kolayca AND eklemek 1=1

if(isset($_GET["arama"]) && $_GET["arama"] != "") {

    $arama = $_GET["arama"];

    $sql .= " AND (
        baslangic LIKE '%$arama%' 
        OR bitis LIKE '%$arama%'
    )";
}


if(isset($_GET["sirala"])) {

    if($_GET["sirala"]=="baslangic"){

        $sql .= " ORDER BY baslangic ASC";

    }

    elseif($_GET["sirala"]=="sure"){

        $sql .= " ORDER BY sure ASC";

    }

    elseif($_GET["sirala"]=="yeniler"){

        $sql .= " ORDER BY guzergah_id DESC";

    }

}

$sonuc=mysqli_query($baglanti,$sql);




?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>OTOBÜS YÖNETİM SİSTEMİ</title>
    <link rel="stylesheet" href="style.css">
    <link rel="stylesheet" href="form.css">
</head>
<body>
    <?php include 'header.php' ?>
    <section class="ana">
        <h3>GÜZERGAH BİLGİLERİ</h3>
      
      

    
      <!--Sıralama Formu -->
    <form method="GET" class="siralama-formu">

        <!--Arama Sonradan ekle-->
        <input   type="text"  name="arama"  placeholder="Başlangıç veya bitiş ara..." value="<?php echo isset($_GET['arama']) ? $_GET['arama'] : ''; ?>"
    >



                <select name="sirala">

                    <option value="">Seçiniz</option>

                    <option value="baslangic">
                        Başlangıç
                    </option>

                    <option value="sure">
                        Süre
                    </option>

                    <option value="yeniler">
                        En Yeni
                    </option>

                </select>

                <button type="submit">Filtrele</button>
                 <button type="reset">Temizle</button>

       </form>

   
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
                        <!-- <a href="guzergah.php?sil=<?php echo $dizi["guzergah_id"] ?>" onclick="return confirm('Bu güzergah verisini silmek istediğinden emin misiniz?')">🗑️</a> -->
                    <a href="#"  onclick="silModalAc('guzergah.php?sil=<?php echo $dizi['guzergah_id']; ?>',
                        'Bu güzergah verisini silmek istediğinizden emin misiniz?'
                        )">
                        🗑️
                        </a>

                  </td> 
                  

            </tr>
            
            <?php } ?>

            
        </table>
       
          
    </section>
    <?php include "modal.php"; ?>

<script src="modal.js"></script>
</body>
</html>