-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Anamakine: 127.0.0.1
-- Üretim Zamanı: 06 May 2026, 08:34:02
-- Sunucu sürümü: 10.4.32-MariaDB
-- PHP Sürümü: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Veritabanı: `otobus`
--

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `guzergah`
--

CREATE TABLE `guzergah` (
  `guzergah_id` int(11) NOT NULL,
  `baslangic` varchar(100) NOT NULL,
  `bitis` varchar(100) NOT NULL,
  `sure` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_turkish_ci;

--
-- Tablo döküm verisi `guzergah`
--

INSERT INTO `guzergah` (`guzergah_id`, `baslangic`, `bitis`, `sure`) VALUES
(1, 'Yukarı Kayabaşı', 'Selçuk', 20),
(2, 'Yukarı Kayabaşı', 'İlhanlı', 15),
(3, 'Aşağı Kayabaşı', 'Terminal', 25);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `otobusler`
--

CREATE TABLE `otobusler` (
  `otobus_id` int(11) NOT NULL,
  `plaka` varchar(20) NOT NULL,
  `guzergah_id` int(11) NOT NULL,
  `sofor_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_turkish_ci;

--
-- Tablo döküm verisi `otobusler`
--

INSERT INTO `otobusler` (`otobus_id`, `plaka`, `guzergah_id`, `sofor_id`) VALUES
(1, '51 AB 101 ', 1, 1),
(2, '51 AB 500 ', 2, 3),
(4, '51 AB 189', 2, 2),
(5, '51 AB 778', 3, 3),
(7, '51 AB 101 ', 1, 3),
(8, '51 AB 189', 2, 1),
(10, '01 AB 456', 2, 2);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `soforler`
--

CREATE TABLE `soforler` (
  `sofor_id` int(11) NOT NULL,
  `ad_soyad` varchar(100) NOT NULL,
  `telefon` varchar(15) NOT NULL,
  `yas` int(2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_turkish_ci;

--
-- Tablo döküm verisi `soforler`
--

INSERT INTO `soforler` (`sofor_id`, `ad_soyad`, `telefon`, `yas`) VALUES
(1, 'Mehmet Kara', '05559858633', 42),
(2, 'Emin Sağır', '05559858599', 55),
(3, 'Sezer Cantur', '05555665253', 34);

--
-- Dökümü yapılmış tablolar için indeksler
--

--
-- Tablo için indeksler `guzergah`
--
ALTER TABLE `guzergah`
  ADD PRIMARY KEY (`guzergah_id`);

--
-- Tablo için indeksler `otobusler`
--
ALTER TABLE `otobusler`
  ADD PRIMARY KEY (`otobus_id`),
  ADD KEY `guzargah_id` (`guzergah_id`),
  ADD KEY `sofor_id` (`sofor_id`);

--
-- Tablo için indeksler `soforler`
--
ALTER TABLE `soforler`
  ADD PRIMARY KEY (`sofor_id`);

--
-- Dökümü yapılmış tablolar için AUTO_INCREMENT değeri
--

--
-- Tablo için AUTO_INCREMENT değeri `guzergah`
--
ALTER TABLE `guzergah`
  MODIFY `guzergah_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Tablo için AUTO_INCREMENT değeri `otobusler`
--
ALTER TABLE `otobusler`
  MODIFY `otobus_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- Tablo için AUTO_INCREMENT değeri `soforler`
--
ALTER TABLE `soforler`
  MODIFY `sofor_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Dökümü yapılmış tablolar için kısıtlamalar
--

--
-- Tablo kısıtlamaları `otobusler`
--
ALTER TABLE `otobusler`
  ADD CONSTRAINT `otobusler_ibfk_1` FOREIGN KEY (`guzergah_id`) REFERENCES `guzergah` (`guzergah_id`),
  ADD CONSTRAINT `otobusler_ibfk_2` FOREIGN KEY (`sofor_id`) REFERENCES `soforler` (`sofor_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
