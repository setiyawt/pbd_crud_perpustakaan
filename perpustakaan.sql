-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               10.4.32-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Version:             12.1.0.6537
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for perpustakaan
DROP DATABASE IF EXISTS `perpustakaan`;
CREATE DATABASE IF NOT EXISTS `perpustakaan` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;
USE `perpustakaan`;

-- Dumping structure for table perpustakaan.anggota
DROP TABLE IF EXISTS `anggota`;
CREATE TABLE IF NOT EXISTS `anggota` (
  `anggota_id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL DEFAULT '0',
  `email` varchar(120) NOT NULL DEFAULT '0',
  `nama` varchar(50) DEFAULT NULL,
  `noHp` varchar(50) DEFAULT NULL,
  `tgl_gabung` date DEFAULT NULL,
  `nama_jln` varchar(50) DEFAULT NULL,
  `kota` varchar(50) DEFAULT NULL,
  `kodepos` varchar(50) DEFAULT NULL,
  `aktif` enum('Y','N') DEFAULT NULL,
  `level` enum('admin','user') DEFAULT NULL,
  PRIMARY KEY (`anggota_id`),
  KEY `level` (`level`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Data exporting was unselected.

-- Dumping structure for table perpustakaan.buku
DROP TABLE IF EXISTS `buku`;
CREATE TABLE IF NOT EXISTS `buku` (
  `buku_id` int(11) NOT NULL,
  `judul` varchar(50) DEFAULT NULL,
  `penulis` varchar(50) DEFAULT NULL,
  `penerbit` varchar(50) DEFAULT NULL,
  `tahun_terbit` year(4) DEFAULT NULL,
  `kategori` varchar(50) DEFAULT NULL,
  `stok` int(11) DEFAULT NULL,
  `tarif_sewa` int(11) DEFAULT NULL,
  `anggota_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`buku_id`),
  KEY `tarif_sewa` (`tarif_sewa`),
  KEY `anggota_id` (`anggota_id`),
  CONSTRAINT `anggota_id` FOREIGN KEY (`anggota_id`) REFERENCES `anggota` (`anggota_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Data exporting was unselected.

-- Dumping structure for table perpustakaan.karyawan
DROP TABLE IF EXISTS `karyawan`;
CREATE TABLE IF NOT EXISTS `karyawan` (
  `karyawan_id` int(11) NOT NULL,
  `nama` varchar(50) DEFAULT NULL,
  `noHp` varchar(50) DEFAULT NULL,
  `nama_jln` varchar(50) DEFAULT NULL,
  `kota` varchar(50) DEFAULT NULL,
  `kodepos` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`karyawan_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Data exporting was unselected.

-- Dumping structure for table perpustakaan.kategori
DROP TABLE IF EXISTS `kategori`;
CREATE TABLE IF NOT EXISTS `kategori` (
  `kategori_id` int(11) NOT NULL,
  `nama` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`kategori_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Data exporting was unselected.

-- Dumping structure for table perpustakaan.keranjang
DROP TABLE IF EXISTS `keranjang`;
CREATE TABLE IF NOT EXISTS `keranjang` (
  `id_keranjang` int(11) NOT NULL AUTO_INCREMENT,
  `buku_id` int(11) NOT NULL,
  `judul` varchar(50) DEFAULT NULL,
  `penulis` varchar(50) DEFAULT NULL,
  `kategori` varchar(50) DEFAULT NULL,
  `tarif_sewa` int(11) DEFAULT NULL,
  `stok` int(11) DEFAULT NULL,
  `lama_pinjam` int(11) DEFAULT NULL,
  `total` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_keranjang`),
  KEY `buku_id` (`buku_id`)
) ENGINE=InnoDB AUTO_INCREMENT=120 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Data exporting was unselected.

-- Dumping structure for table perpustakaan.login
DROP TABLE IF EXISTS `login`;
CREATE TABLE IF NOT EXISTS `login` (
  `id_anggota` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) DEFAULT NULL,
  `password` varchar(50) DEFAULT NULL,
  `level` enum('admin','user') DEFAULT NULL,
  PRIMARY KEY (`id_anggota`) USING BTREE,
  KEY `level` (`level`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Data exporting was unselected.

-- Dumping structure for table perpustakaan.peminjaman
DROP TABLE IF EXISTS `peminjaman`;
CREATE TABLE IF NOT EXISTS `peminjaman` (
  `peminjaman_id` int(11) NOT NULL AUTO_INCREMENT,
  `anggota_id` int(11) DEFAULT NULL,
  `buku_id` int(11) DEFAULT NULL,
  `karyawan_id` int(11) DEFAULT NULL,
  `tgl_pinjam` date DEFAULT NULL,
  `lama_pinjam` int(11) DEFAULT NULL,
  `tarif_sewa` int(11) DEFAULT NULL,
  `total` int(11) DEFAULT NULL,
  PRIMARY KEY (`peminjaman_id`),
  KEY `anggota_id` (`anggota_id`),
  KEY `buku_id` (`buku_id`),
  KEY `karyawan_id` (`karyawan_id`),
  KEY `tarif_sewa` (`tarif_sewa`),
  CONSTRAINT `anggota` FOREIGN KEY (`anggota_id`) REFERENCES `anggota` (`anggota_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `buku` FOREIGN KEY (`buku_id`) REFERENCES `buku` (`buku_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `karyawan` FOREIGN KEY (`karyawan_id`) REFERENCES `karyawan` (`karyawan_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `tarif_sewa` FOREIGN KEY (`tarif_sewa`) REFERENCES `buku` (`tarif_sewa`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Data exporting was unselected.

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
