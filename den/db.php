<?php

$baglanti=mysqli_connect("localhost","root","","otobus");

if(!$baglanti) {

    die("Veritabanına bağlanamıyor ".mysqli_connect_error());
}

?>