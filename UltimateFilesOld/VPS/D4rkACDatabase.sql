-- --------------------------------------------------------
-- Anfitrião:                    127.0.0.1
-- Versão do servidor:           10.4.22-MariaDB - mariadb.org binary distribution
-- SO do servidor:               Win64
-- HeidiSQL Versão:              11.3.0.6295
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- A despejar estrutura da base de dados para d4rkac
CREATE DATABASE IF NOT EXISTS `d4rkac` /*!40100 DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci */;
USE `d4rkac`;

-- A despejar estrutura para tabela d4rkac.licenses
CREATE TABLE IF NOT EXISTS `licenses` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Owner` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `IP` varchar(20) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `License` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  `Tempo` int(11) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- A despejar dados para tabela d4rkac.licenses: ~2 rows (aproximadamente)
DELETE FROM `licenses`;
/*!40000 ALTER TABLE `licenses` DISABLE KEYS */;
INSERT INTO `licenses` (`ID`, `Owner`, `IP`, `License`, `Tempo`) VALUES
	(1, 'D4rk', '185.113.141.63', 'license:RK9NDTPU7E7K', -1),
	(4, 'D4rk', '127.0.0.1', 'license:ADMINTESTING', -1);
/*!40000 ALTER TABLE `licenses` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
