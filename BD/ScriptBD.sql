CREATE DATABASE  IF NOT EXISTS `vale24h` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `vale24h`;
-- MySQL dump 10.13  Distrib 5.6.24, for Win64 (x86_64)
--
-- Host: localhost    Database: vale24h
-- ------------------------------------------------------
-- Server version	5.6.23-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `categoria`
--

DROP TABLE IF EXISTS `categoria`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `categoria` (
  `codigo_cat` bigint(20) NOT NULL AUTO_INCREMENT,
  `descricao_cat` varchar(45) NOT NULL,
  `ativo_cat` tinyint(1) NOT NULL DEFAULT '1',
  `datacad_cat` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usercad_cat` bigint(20) NOT NULL,
  PRIMARY KEY (`codigo_cat`),
  KEY `FK_Categoria_UsuarioCad_idx` (`usercad_cat`),
  CONSTRAINT `FK_Categoria_UsuarioCad` FOREIGN KEY (`usercad_cat`) REFERENCES `usuario` (`codigo_usr`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categoria`
--

LOCK TABLES `categoria` WRITE;
/*!40000 ALTER TABLE `categoria` DISABLE KEYS */;
INSERT INTO `categoria` VALUES (1,'Roupas',1,'2015-07-11 15:48:59',10);
/*!40000 ALTER TABLE `categoria` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cliente`
--

DROP TABLE IF EXISTS `cliente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cliente` (
  `codigo_cli` bigint(20) NOT NULL AUTO_INCREMENT,
  `nome_cli` varchar(100) NOT NULL,
  `useralt_cli` bigint(20) DEFAULT NULL,
  `usercad_cli` bigint(20) NOT NULL,
  `datacad_cli` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `dataalt_cli` datetime DEFAULT NULL,
  `cloudId_cli` varchar(100) NOT NULL,
  `imagem_cli` varchar(150) DEFAULT NULL,
  `codigoUAU_cli` int(11) NOT NULL,
  PRIMARY KEY (`codigo_cli`),
  UNIQUE KEY `cloudId_cli_UNIQUE` (`cloudId_cli`),
  UNIQUE KEY `codigoUAU_cli_UNIQUE` (`codigoUAU_cli`),
  KEY `FK_Cliente_UsuarioCad_idx` (`usercad_cli`),
  KEY `FK_Cliente_UsuarioAlt_idx` (`useralt_cli`),
  CONSTRAINT `FK_Cliente_UsuarioAlt` FOREIGN KEY (`useralt_cli`) REFERENCES `usuario` (`codigo_usr`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_Cliente_UsuarioCad` FOREIGN KEY (`usercad_cli`) REFERENCES `usuario` (`codigo_usr`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cliente`
--

LOCK TABLES `cliente` WRITE;
/*!40000 ALTER TABLE `cliente` DISABLE KEYS */;
INSERT INTO `cliente` VALUES (1,'Hering Store',NULL,10,'2015-07-11 15:47:43',NULL,'5560ee319797df08f8095147','logo.png',1);
/*!40000 ALTER TABLE `cliente` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `imagem`
--

DROP TABLE IF EXISTS `imagem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `imagem` (
  `codigo_img` bigint(20) NOT NULL AUTO_INCREMENT,
  `urlRelativa_img` varchar(100) NOT NULL,
  `Cliente_codigo_cli` bigint(20) NOT NULL,
  PRIMARY KEY (`codigo_img`),
  KEY `fk_Imagem_Cliente1_idx` (`Cliente_codigo_cli`),
  CONSTRAINT `fk_Imagem_Cliente1` FOREIGN KEY (`Cliente_codigo_cli`) REFERENCES `cliente` (`codigo_cli`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `imagem`
--

LOCK TABLES `imagem` WRITE;
/*!40000 ALTER TABLE `imagem` DISABLE KEYS */;
INSERT INTO `imagem` VALUES (1,'0.png',1),(2,'1.png',1),(3,'2.png',1),(4,'3.png',1),(5,'4.png',1),(6,'5.png',1),(7,'6.png',1),(8,'7.png',1),(9,'8.png',1),(10,'9.png',1),(11,'10.png',1),(12,'11.png',1),(13,'12.png',1),(14,'13.png',1),(15,'14.png',1),(16,'15.png',1),(17,'16.png',1),(18,'17.png',1),(19,'18.png',1),(20,'19.png',1),(21,'20.png',1),(22,'21.png',1),(23,'22.png',1),(24,'23.png',1),(25,'24.png',1),(26,'25.png',1),(27,'26.png',1),(28,'27.png',1),(29,'28.png',1),(30,'29.png',1),(31,'30.png',1),(32,'31.png',1);
/*!40000 ALTER TABLE `imagem` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `promocao`
--

DROP TABLE IF EXISTS `promocao`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `promocao` (
  `codigo_pro` bigint(20) NOT NULL AUTO_INCREMENT,
  `cliente_pro` bigint(20) NOT NULL,
  `Imagem_codigo_pro` bigint(20) NOT NULL,
  `titulo_pro` varchar(30) NOT NULL,
  `descricao_pro` varchar(2500) NOT NULL,
  `datainicio_pro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `datafim_pro` datetime NOT NULL,
  `datacad_pro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `limitada_pro` tinyint(1) NOT NULL DEFAULT '1',
  `totalTickets_pro` int(11) NOT NULL,
  `latitude_pro` varchar(20) NOT NULL,
  `longitude_pro` varchar(20) NOT NULL,
  `iniciada_pro` tinyint(1) NOT NULL DEFAULT '0',
  `ativa_pro` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`codigo_pro`),
  KEY `FK_Promocao_Cliente_idx` (`cliente_pro`),
  KEY `fk_Promocao_Imagem1_idx` (`Imagem_codigo_pro`),
  CONSTRAINT `FK_Promocao_Cliente` FOREIGN KEY (`cliente_pro`) REFERENCES `cliente` (`codigo_cli`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_Promocao_Imagem1` FOREIGN KEY (`Imagem_codigo_pro`) REFERENCES `imagem` (`codigo_img`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=209 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `promocao`
--

LOCK TABLES `promocao` WRITE;
/*!40000 ALTER TABLE `promocao` DISABLE KEYS */;
INSERT INTO `promocao` VALUES (107,1,22,'semper','dictum magna. Ut tincidunt orci quis lectus. Nullam suscipit, est ac facilisis facilisis, magna tellus faucibus leo, in lobortis tellus justo sit amet nulla. Donec non justo. Proin non massa non ante bibendum ullamcorper. Duis cursus, diam at pretium aliquet, metus','2015-02-05 21:37:06','2016-01-23 12:37:12','2015-07-11 20:23:09',1,11,'74.20331','106.49821',1,1),(108,1,30,'et,','molestie in, tempus eu, ligula. Aenean euismod mauris eu elit. Nulla facilisi. Sed neque. Sed eget lacus. Mauris non dui nec urna suscipit nonummy. Fusce fermentum','2015-05-06 08:51:37','2016-01-20 22:16:49','2015-07-11 20:23:09',1,11,'31.03112','110.19172',1,1),(109,1,30,'Curae; Donec tincidunt.','nunc sed libero. Proin sed turpis nec mauris blandit mattis. Cras eget nisi dictum augue malesuada malesuada. Integer id magna et ipsum cursus vestibulum. Mauris magna.','2015-03-15 05:47:19','2016-03-02 04:14:44','2015-07-11 20:23:09',1,5,'20.5717','115.6955',1,1),(110,1,2,'dolor','adipiscing. Mauris molestie pharetra nibh. Aliquam ornare, libero at auctor ullamcorper, nisl arcu iaculis enim, sit amet ornare lectus justo eu arcu. Morbi sit amet massa. Quisque porttitor eros nec','2015-01-30 07:33:49','2016-01-18 19:07:04','2015-07-11 20:23:09',1,6,'-43.83088','-165.51433',1,1),(111,1,31,'risus.','eget, volutpat ornare, facilisis eget, ipsum. Donec sollicitudin adipiscing ligula. Aenean gravida nunc sed pede. Cum sociis natoque penatibus et','2015-06-17 16:24:18','2016-02-24 14:26:17','2015-07-11 20:23:09',1,8,'-40.8989','-43.16759',1,1),(112,1,4,'euismod','diam at pretium aliquet, metus urna convallis erat, eget tincidunt dui augue eu tellus. Phasellus elit pede, malesuada vel, venenatis vel, faucibus id, libero. Donec consectetuer mauris id sapien. Cras dolor dolor, tempus non, lacinia at, iaculis quis, pede. Praesent eu dui. Cum sociis natoque penatibus et magnis dis parturient','2015-06-17 22:16:31','2016-06-24 07:47:15','2015-07-11 20:23:09',1,13,'-15.52039','13.32369',1,1),(113,1,10,'lectus pede, ultrices','lacus. Ut nec urna et arcu imperdiet ullamcorper. Duis at lacus. Quisque purus sapien, gravida non, sollicitudin a, malesuada id, erat. Etiam vestibulum massa rutrum','2015-05-31 04:36:04','2016-01-04 05:55:10','2015-07-11 20:23:09',1,6,'74.06105','-70.94385',1,1),(114,1,13,'ullamcorper, nisl','enim. Etiam imperdiet dictum magna. Ut tincidunt orci quis lectus. Nullam suscipit, est ac facilisis facilisis, magna tellus faucibus leo, in lobortis tellus justo sit amet nulla. Donec non justo. Proin non massa non ante bibendum ullamcorper. Duis cursus,','2015-03-08 06:35:53','2016-07-30 02:18:23','2015-07-11 20:23:09',1,7,'-65.95821','111.19592',1,1),(115,1,20,'vitae odio sagittis','euismod est arcu ac orci. Ut semper pretium neque. Morbi quis urna. Nunc quis arcu vel quam dignissim pharetra. Nam ac nulla. In tincidunt congue turpis. In condimentum. Donec at arcu. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere','2015-03-07 18:49:17','2016-06-08 21:34:00','2015-07-11 20:23:09',1,8,'38.12937','-148.63185',1,1),(116,1,12,'sapien imperdiet ornare.','nec luctus felis purus ac tellus. Suspendisse sed dolor. Fusce mi lorem, vehicula et, rutrum eu, ultrices sit amet, risus. Donec nibh enim, gravida sit amet, dapibus id, blandit at, nisi. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Proin vel nisl. Quisque fringilla euismod','2015-04-25 11:35:09','2016-03-30 22:12:01','2015-07-11 20:23:09',1,8,'-37.6142','-82.04726',1,1),(117,1,4,'mattis semper, dui','lorem fringilla ornare placerat, orci lacus vestibulum lorem, sit amet ultricies sem magna nec quam. Curabitur vel lectus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec dignissim magna a tortor. Nunc commodo auctor velit. Aliquam nisl. Nulla eu neque','2015-04-14 21:36:17','2016-02-03 08:57:48','2015-07-11 20:23:09',1,12,'54.6548','107.62449',1,1),(118,1,7,'Fusce dolor','auctor velit. Aliquam nisl. Nulla eu neque pellentesque massa lobortis ultrices. Vivamus rhoncus. Donec est. Nunc ullamcorper, velit in aliquet lobortis, nisi nibh lacinia orci, consectetuer euismod est arcu ac orci. Ut semper pretium neque. Morbi quis urna. Nunc quis arcu vel quam dignissim pharetra. Nam ac nulla. In','2015-06-20 05:28:10','2016-03-18 19:28:38','2015-07-11 20:23:09',1,15,'8.14873','152.97678',1,1),(119,1,22,'pede. Suspendisse','fermentum vel, mauris. Integer sem elit, pharetra ut, pharetra sed, hendrerit a, arcu. Sed et libero. Proin mi. Aliquam gravida mauris ut mi. Duis risus odio, auctor vitae, aliquet nec,','2015-01-27 03:24:41','2016-04-21 22:53:07','2015-07-11 20:23:09',1,12,'50.63384','-4.16133',1,1),(120,1,23,'scelerisque','felis purus ac tellus. Suspendisse sed dolor. Fusce mi lorem, vehicula et, rutrum eu, ultrices sit amet, risus. Donec nibh enim, gravida sit amet, dapibus id, blandit at, nisi. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Proin vel nisl. Quisque fringilla euismod enim.','2015-06-02 12:56:36','2016-02-15 11:07:43','2015-07-11 20:23:09',1,13,'5.79264','-25.70386',1,1),(121,1,30,'Nunc mauris','et tristique pellentesque, tellus sem mollis dui, in sodales elit erat vitae risus. Duis a mi fringilla mi lacinia mattis. Integer eu lacus. Quisque','2015-06-22 22:56:37','2016-05-16 05:19:07','2015-07-11 20:23:09',1,14,'-79.42165','44.76666',1,1),(122,1,5,'cursus. Integer mollis.','sagittis felis. Donec tempor, est ac mattis semper, dui lectus rutrum urna, nec luctus felis purus ac tellus. Suspendisse sed dolor. Fusce mi lorem, vehicula et, rutrum eu, ultrices sit amet, risus. Donec nibh enim, gravida sit amet,','2015-05-05 00:22:35','2016-06-11 10:51:31','2015-07-11 20:23:09',1,8,'-86.32434','51.3827',1,1),(123,1,10,'Lorem ipsum dolor','pellentesque eget, dictum placerat, augue. Sed molestie. Sed id risus quis diam luctus lobortis. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos hymenaeos. Mauris ut quam vel sapien imperdiet ornare. In faucibus. Morbi','2015-01-29 02:59:54','2016-05-15 14:13:12','2015-07-11 20:23:09',1,7,'-80.74385','-25.30701',1,1),(124,1,16,'condimentum. Donec at','dis parturient montes, nascetur ridiculus mus. Proin vel nisl. Quisque fringilla euismod enim. Etiam gravida molestie arcu. Sed eu nibh vulputate mauris sagittis placerat. Cras dictum ultricies ligula. Nullam','2015-06-19 05:55:38','2016-01-06 20:22:05','2015-07-11 20:23:09',1,13,'56.46462','145.76692',1,1),(125,1,14,'lobortis, nisi','posuere cubilia Curae; Phasellus ornare. Fusce mollis. Duis sit amet diam eu dolor egestas rhoncus. Proin nisl sem, consequat nec, mollis vitae, posuere at, velit. Cras lorem lorem, luctus ut, pellentesque eget,','2015-02-01 10:44:44','2016-06-10 22:37:39','2015-07-11 20:23:09',1,7,'44.67567','-3.56362',1,1),(126,1,12,'amet metus. Aliquam','Sed molestie. Sed id risus quis diam luctus lobortis. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos hymenaeos. Mauris ut quam vel sapien imperdiet ornare. In faucibus. Morbi vehicula. Pellentesque tincidunt tempus risus. Donec egestas. Duis ac arcu. Nunc mauris. Morbi non sapien molestie','2015-03-30 14:20:00','2016-05-17 01:50:53','2015-07-11 20:23:09',1,8,'-62.10097','-45.05544',1,1),(127,1,16,'Morbi','Suspendisse sagittis. Nullam vitae diam. Proin dolor. Nulla semper tellus id nunc interdum feugiat. Sed nec metus facilisis lorem tristique aliquet. Phasellus fermentum convallis ligula. Donec luctus aliquet odio. Etiam','2015-06-28 21:38:12','2016-05-18 07:25:55','2015-07-11 20:23:09',1,15,'4.78613','-156.10609',1,1),(128,1,14,'eleifend','Integer vitae nibh. Donec est mauris, rhoncus id, mollis nec, cursus a, enim. Suspendisse aliquet, sem ut cursus luctus, ipsum leo elementum sem,','2015-03-26 12:30:04','2016-05-17 11:21:21','2015-07-11 20:23:10',1,9,'-77.78606','-139.05685',1,1),(129,1,5,'facilisis lorem tristique','magna. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Etiam laoreet, libero et tristique pellentesque, tellus sem mollis dui, in sodales elit erat','2015-02-18 23:00:02','2016-07-15 07:47:41','2015-07-11 20:23:10',1,13,'-4.38791','150.082',1,1),(130,1,28,'tempus scelerisque, lorem','leo, in lobortis tellus justo sit amet nulla. Donec non justo. Proin non massa non ante bibendum ullamcorper. Duis cursus, diam','2015-02-06 13:53:32','2016-03-26 00:32:44','2015-07-11 20:23:10',1,7,'-18.57931','-81.47495',1,1),(131,1,15,'lacus. Quisque','Nam ac nulla. In tincidunt congue turpis. In condimentum. Donec at arcu. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec tincidunt. Donec vitae erat vel pede blandit congue. In scelerisque scelerisque dui. Suspendisse ac metus vitae velit egestas lacinia. Sed congue, elit','2015-02-01 19:15:50','2016-01-02 16:31:55','2015-07-11 20:23:10',1,3,'49.21535','-11.68579',1,1),(132,1,2,'a feugiat','Curae; Phasellus ornare. Fusce mollis. Duis sit amet diam eu dolor egestas rhoncus. Proin nisl sem, consequat nec, mollis vitae, posuere at,','2015-04-03 16:06:54','2016-03-01 11:52:58','2015-07-11 20:23:10',1,15,'38.66494','-55.68157',1,1),(133,1,12,'mauris','sed leo. Cras vehicula aliquet libero. Integer in magna. Phasellus dolor elit, pellentesque a, facilisis non, bibendum sed, est. Nunc laoreet lectus quis massa. Mauris vestibulum, neque sed dictum eleifend,','2015-01-23 02:09:22','2016-06-07 08:21:51','2015-07-11 20:23:10',1,8,'14.74003','142.08063',1,1),(134,1,15,'dolor. Nulla semper','id ante dictum cursus. Nunc mauris elit, dictum eu, eleifend nec, malesuada ut, sem. Nulla interdum. Curabitur dictum. Phasellus in felis. Nulla tempor augue ac ipsum. Phasellus vitae mauris sit amet','2015-03-22 22:30:02','2016-05-18 00:07:44','2015-07-11 20:23:10',1,4,'-13.00638','-127.40528',1,1),(135,1,2,'odio tristique','nulla at sem molestie sodales. Mauris blandit enim consequat purus. Maecenas libero est, congue a, aliquet vel, vulputate eu, odio. Phasellus at augue id ante dictum cursus. Nunc mauris','2015-06-23 11:42:09','2016-05-06 04:31:04','2015-07-11 20:23:10',1,10,'46.46799','-114.24401',1,1),(136,1,9,'quis massa.','vulputate, posuere vulputate, lacus. Cras interdum. Nunc sollicitudin commodo ipsum. Suspendisse non leo. Vivamus nibh dolor, nonummy ac, feugiat non, lobortis quis, pede. Suspendisse','2015-04-04 14:53:42','2016-01-09 12:50:31','2015-07-11 20:23:10',1,10,'70.79575','1.64931',1,1),(137,1,25,'amet ultricies sem','sit amet, faucibus ut, nulla. Cras eu tellus eu augue porttitor interdum. Sed auctor odio a purus. Duis elementum, dui quis accumsan convallis, ante lectus convallis est, vitae sodales nisi magna','2015-06-09 01:14:14','2016-05-13 10:18:54','2015-07-11 20:23:10',1,14,'7.77766','37.05927',1,1),(138,1,32,'gravida','adipiscing. Mauris molestie pharetra nibh. Aliquam ornare, libero at auctor ullamcorper, nisl arcu iaculis enim, sit amet ornare lectus justo eu arcu. Morbi sit amet massa. Quisque porttitor eros nec tellus. Nunc lectus pede, ultrices a, auctor non, feugiat nec, diam. Duis mi enim,','2015-03-13 11:31:36','2016-03-05 06:38:06','2015-07-11 20:23:10',1,4,'-6.00449','-75.39397',1,1),(139,1,13,'turpis','mattis ornare, lectus ante dictum mi, ac mattis velit justo nec ante. Maecenas mi felis, adipiscing fringilla, porttitor vulputate, posuere vulputate, lacus. Cras interdum. Nunc sollicitudin commodo ipsum. Suspendisse non leo. Vivamus nibh dolor, nonummy ac, feugiat non, lobortis quis, pede. Suspendisse dui. Fusce diam','2015-02-17 13:35:45','2016-06-07 17:42:16','2015-07-11 20:23:10',1,14,'22.56537','-148.76438',1,1),(140,1,5,'aliquam','lacus, varius et, euismod et, commodo at, libero. Morbi accumsan laoreet ipsum. Curabitur consequat, lectus sit amet luctus vulputate, nisi sem semper erat, in consectetuer ipsum nunc id enim. Curabitur massa. Vestibulum accumsan neque et nunc. Quisque ornare tortor at risus. Nunc ac sem ut dolor dapibus gravida.','2015-04-15 01:32:04','2016-05-02 16:47:58','2015-07-11 20:23:10',1,12,'0.04491','3.78025',1,1),(141,1,7,'neque','sit amet, consectetuer adipiscing elit. Etiam laoreet, libero et tristique pellentesque, tellus sem mollis dui, in sodales elit erat vitae risus. Duis a mi fringilla mi lacinia mattis. Integer eu lacus. Quisque imperdiet, erat nonummy ultricies ornare, elit','2015-06-04 11:56:04','2016-03-03 01:04:40','2015-07-11 20:23:10',1,9,'-79.26339','57.1474',1,1),(142,1,4,'augue ut lacus.','facilisis lorem tristique aliquet. Phasellus fermentum convallis ligula. Donec luctus aliquet odio. Etiam ligula tortor, dictum eu, placerat eget, venenatis a, magna. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Etiam laoreet, libero et tristique pellentesque,','2015-02-19 19:42:25','2016-06-22 21:34:57','2015-07-11 20:23:10',1,9,'-19.7912','50.08397',1,1),(143,1,22,'tristique','neque. Sed eget lacus. Mauris non dui nec urna suscipit nonummy. Fusce fermentum fermentum arcu. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Phasellus ornare. Fusce mollis. Duis sit amet diam eu dolor egestas','2015-04-01 09:12:33','2016-01-13 05:33:49','2015-07-11 20:23:10',1,15,'-14.31503','-34.87335',1,1),(144,1,32,'rhoncus id,','eget metus eu erat semper rutrum. Fusce dolor quam, elementum at, egestas a, scelerisque sed, sapien. Nunc pulvinar arcu et pede. Nunc sed orci lobortis augue scelerisque mollis. Phasellus libero mauris, aliquam','2015-02-15 22:54:04','2016-04-07 21:37:43','2015-07-11 20:23:10',1,15,'24.42465','-143.756',1,1),(145,1,32,'posuere cubilia','augue ac ipsum. Phasellus vitae mauris sit amet lorem semper auctor. Mauris vel turpis. Aliquam adipiscing lobortis risus. In mi pede, nonummy ut, molestie in, tempus eu, ligula. Aenean euismod mauris eu elit. Nulla facilisi. Sed neque. Sed eget lacus. Mauris non dui nec urna suscipit nonummy. Fusce','2015-03-12 12:59:53','2016-04-30 16:29:43','2015-07-11 20:23:10',1,4,'30.48907','117.49964',1,1),(146,1,2,'lacus. Quisque purus','egestas a, scelerisque sed, sapien. Nunc pulvinar arcu et pede. Nunc sed orci lobortis augue scelerisque mollis. Phasellus libero mauris, aliquam eu, accumsan sed, facilisis vitae, orci. Phasellus dapibus quam quis diam. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Fusce aliquet magna a','2015-02-15 22:11:33','2016-01-13 12:43:20','2015-07-11 20:23:10',1,10,'42.60407','-173.48478',1,1),(147,1,3,'consectetuer mauris id','Mauris eu turpis. Nulla aliquet. Proin velit. Sed malesuada augue ut lacus. Nulla tincidunt, neque vitae semper egestas, urna justo faucibus lectus, a sollicitudin orci sem eget massa. Suspendisse eleifend. Cras sed leo. Cras vehicula aliquet libero.','2015-01-10 00:13:47','2016-05-07 23:49:09','2015-07-11 20:23:10',1,13,'-44.12565','103.67563',1,1),(148,1,9,'vitae risus. Duis','in felis. Nulla tempor augue ac ipsum. Phasellus vitae mauris sit amet lorem semper auctor. Mauris vel turpis. Aliquam adipiscing lobortis risus. In mi pede, nonummy ut, molestie','2015-04-12 01:42:20','2016-03-20 05:09:56','2015-07-11 20:23:10',1,14,'33.29352','-121.61372',1,1),(149,1,12,'enim.','dictum. Proin eget odio. Aliquam vulputate ullamcorper magna. Sed eu eros. Nam consequat dolor vitae dolor. Donec fringilla. Donec feugiat metus sit amet ante. Vivamus non lorem vitae odio sagittis semper. Nam tempor diam dictum sapien. Aenean massa. Integer vitae nibh.','2015-04-22 19:09:13','2016-03-08 16:17:52','2015-07-11 20:23:10',1,14,'-77.70534','-12.64515',1,1),(150,1,24,'nec, diam.','ultricies adipiscing, enim mi tempor lorem, eget mollis lectus pede et risus. Quisque libero lacus, varius et, euismod et, commodo at, libero. Morbi accumsan laoreet ipsum. Curabitur consequat, lectus sit amet luctus vulputate,','2015-03-16 21:10:28','2016-05-18 06:07:38','2015-07-11 20:23:10',1,10,'-14.49172','-169.63135',1,1),(151,1,29,'mauris sit amet','et, magna. Praesent interdum ligula eu enim. Etiam imperdiet dictum magna. Ut tincidunt orci quis lectus. Nullam suscipit, est ac facilisis facilisis, magna tellus faucibus leo, in lobortis tellus justo sit amet nulla. Donec non justo. Proin non','2015-03-21 23:06:38','2016-05-19 17:50:41','2015-07-11 20:23:10',1,10,'39.36758','-5.31598',1,1),(152,1,13,'suscipit nonummy. Fusce','molestie dapibus ligula. Aliquam erat volutpat. Nulla dignissim. Maecenas ornare egestas ligula. Nullam feugiat placerat velit. Quisque varius. Nam porttitor scelerisque neque. Nullam nisl. Maecenas malesuada fringilla est. Mauris eu turpis. Nulla aliquet. Proin velit. Sed malesuada augue ut lacus. Nulla tincidunt, neque vitae','2015-04-03 10:06:46','2016-03-11 00:06:44','2015-07-11 20:23:10',1,4,'-34.2576','-81.95155',1,1),(153,1,1,'viverra.','nec, cursus a, enim. Suspendisse aliquet, sem ut cursus luctus, ipsum leo elementum sem, vitae aliquam eros turpis non enim. Mauris','2015-06-10 20:46:36','2016-04-02 02:01:04','2015-07-11 20:23:10',1,4,'55.92686','-68.45291',1,1),(154,1,22,'libero est, congue','mollis dui, in sodales elit erat vitae risus. Duis a mi fringilla mi lacinia mattis. Integer eu lacus. Quisque imperdiet, erat nonummy ultricies ornare, elit elit fermentum risus, at fringilla purus mauris a nunc. In at pede. Cras vulputate velit eu sem. Pellentesque ut ipsum ac','2015-05-04 15:44:57','2016-02-22 13:18:56','2015-07-11 20:23:10',1,10,'-10.2099','-81.599',1,1),(155,1,23,'In ornare sagittis','eu, eleifend nec, malesuada ut, sem. Nulla interdum. Curabitur dictum. Phasellus in felis. Nulla tempor augue ac ipsum. Phasellus vitae mauris sit amet lorem semper auctor. Mauris vel turpis. Aliquam adipiscing lobortis risus. In mi pede, nonummy ut,','2015-02-20 15:24:13','2016-07-15 10:59:31','2015-07-11 20:23:10',1,15,'-74.70963','-173.60475',1,1),(156,1,13,'Sed','elit, pellentesque a, facilisis non, bibendum sed, est. Nunc laoreet lectus quis massa. Mauris vestibulum, neque sed dictum eleifend, nunc risus varius orci, in consequat enim diam vel arcu. Curabitur ut odio vel est tempor bibendum. Donec felis orci, adipiscing non, luctus sit amet, faucibus','2015-06-22 22:31:59','2016-01-10 12:36:58','2015-07-11 20:23:10',1,13,'-26.66308','-55.18343',1,1),(157,1,26,'Curabitur','primis in faucibus orci luctus et ultrices posuere cubilia Curae; Phasellus ornare. Fusce mollis. Duis sit amet diam eu dolor egestas rhoncus. Proin nisl','2015-02-04 10:25:15','2016-03-23 00:21:33','2015-07-11 20:23:10',1,14,'-83.94772','-36.96055',1,1),(158,1,6,'elit,','sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec dignissim magna a tortor. Nunc commodo auctor velit. Aliquam nisl. Nulla eu neque pellentesque massa lobortis ultrices. Vivamus rhoncus. Donec est. Nunc ullamcorper, velit in aliquet lobortis, nisi nibh lacinia orci, consectetuer euismod est arcu','2015-03-02 09:08:25','2016-04-30 13:58:44','2015-07-11 20:23:10',1,3,'84.08284','-5.91986',1,1),(159,1,27,'aliquet. Phasellus','ac, feugiat non, lobortis quis, pede. Suspendisse dui. Fusce diam nunc, ullamcorper eu, euismod ac, fermentum vel, mauris. Integer sem elit, pharetra ut, pharetra sed, hendrerit a, arcu. Sed et libero. Proin mi. Aliquam gravida','2015-01-22 14:07:03','2016-01-15 08:52:12','2015-07-11 20:23:10',1,9,'-7.69808','39.42522',1,1),(160,1,17,'sed sem','cursus a, enim. Suspendisse aliquet, sem ut cursus luctus, ipsum leo elementum sem, vitae aliquam eros turpis non enim. Mauris quis turpis vitae purus gravida sagittis. Duis gravida. Praesent eu nulla at sem molestie sodales. Mauris blandit enim consequat purus. Maecenas libero est, congue a, aliquet vel, vulputate','2015-01-24 22:48:54','2016-04-17 01:29:04','2015-07-11 20:23:10',1,15,'63.41565','131.03614',1,1),(161,1,11,'volutpat','sed, hendrerit a, arcu. Sed et libero. Proin mi. Aliquam gravida mauris ut mi. Duis risus odio, auctor vitae, aliquet nec, imperdiet nec, leo. Morbi neque tellus, imperdiet non, vestibulum nec,','2015-06-20 20:56:48','2016-05-24 22:03:57','2015-07-11 20:23:10',1,3,'29.48166','-74.53619',1,1),(162,1,3,'Curabitur','Proin velit. Sed malesuada augue ut lacus. Nulla tincidunt, neque vitae semper egestas, urna justo faucibus lectus, a sollicitudin orci sem eget massa. Suspendisse eleifend. Cras sed leo. Cras vehicula','2015-04-23 14:01:55','2016-02-14 12:35:28','2015-07-11 20:23:10',1,12,'-31.23484','173.41044',1,1),(163,1,16,'Maecenas mi felis,','mauris, rhoncus id, mollis nec, cursus a, enim. Suspendisse aliquet, sem ut cursus luctus, ipsum leo elementum sem, vitae aliquam eros turpis non enim. Mauris quis turpis vitae purus gravida sagittis. Duis gravida. Praesent eu nulla at sem molestie sodales. Mauris blandit','2015-01-22 12:09:27','2016-04-06 19:08:03','2015-07-11 20:23:10',1,3,'75.28294','-129.6657',1,1),(164,1,30,'lobortis mauris. Suspendisse','pretium et, rutrum non, hendrerit id, ante. Nunc mauris sapien, cursus in, hendrerit consectetuer, cursus et, magna. Praesent interdum ligula eu enim. Etiam imperdiet dictum magna. Ut tincidunt orci quis lectus. Nullam suscipit, est ac facilisis facilisis, magna tellus faucibus leo, in lobortis tellus justo sit','2015-01-08 23:03:45','2016-02-23 05:49:29','2015-07-11 20:23:10',1,15,'-14.37313','69.12137',1,1),(165,1,10,'interdum. Sed','morbi tristique senectus et netus et malesuada fames ac turpis egestas. Aliquam fringilla cursus purus. Nullam scelerisque neque sed sem egestas blandit. Nam','2015-03-11 17:14:16','2016-04-28 21:26:53','2015-07-11 20:23:10',1,4,'38.55706','-154.12045',1,1),(166,1,18,'Sed','sollicitudin commodo ipsum. Suspendisse non leo. Vivamus nibh dolor, nonummy ac, feugiat non, lobortis quis, pede. Suspendisse dui. Fusce diam nunc, ullamcorper eu, euismod ac, fermentum vel, mauris. Integer sem elit, pharetra ut,','2015-04-24 22:40:31','2016-05-06 01:41:51','2015-07-11 20:23:10',1,10,'-54.13388','-43.76364',1,1),(167,1,1,'arcu. Sed et','ipsum. Suspendisse non leo. Vivamus nibh dolor, nonummy ac, feugiat non, lobortis quis, pede. Suspendisse dui. Fusce diam nunc, ullamcorper eu, euismod ac, fermentum vel, mauris. Integer sem elit, pharetra ut, pharetra sed, hendrerit a, arcu. Sed et libero. Proin mi. Aliquam gravida mauris ut mi. Duis risus odio, auctor','2015-01-21 00:25:18','2016-04-08 02:31:33','2015-07-11 20:23:10',1,3,'-43.11465','153.07858',1,1),(168,1,22,'venenatis a, magna.','In at pede. Cras vulputate velit eu sem. Pellentesque ut ipsum ac mi eleifend egestas. Sed pharetra, felis eget varius ultrices, mauris ipsum porta elit, a feugiat tellus lorem eu','2015-05-08 19:34:37','2016-06-26 14:04:41','2015-07-11 20:23:11',1,4,'26.9474','179.84218',1,1),(169,1,22,'vulputate,','magnis dis parturient montes, nascetur ridiculus mus. Aenean eget magna. Suspendisse tristique neque venenatis lacus. Etiam bibendum fermentum metus. Aenean sed pede nec ante blandit viverra. Donec tempus, lorem fringilla','2015-01-05 04:35:15','2016-03-19 21:02:41','2015-07-11 20:23:11',1,3,'-62.56181','55.15586',1,1),(170,1,24,'odio. Aliquam','pede sagittis augue, eu tempor erat neque non quam. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Aliquam fringilla cursus purus. Nullam scelerisque neque','2015-06-04 21:45:10','2016-07-14 12:53:59','2015-07-11 20:23:11',1,9,'80.0508','144.80305',1,1),(171,1,14,'rhoncus','tempus scelerisque, lorem ipsum sodales purus, in molestie tortor nibh sit amet orci. Ut sagittis lobortis mauris. Suspendisse aliquet molestie tellus. Aenean egestas hendrerit neque. In ornare sagittis','2015-06-27 19:13:53','2016-03-08 03:18:48','2015-07-11 20:23:11',1,4,'-81.93844','25.62807',1,1),(172,1,9,'dictum','lacus, varius et, euismod et, commodo at, libero. Morbi accumsan laoreet ipsum. Curabitur consequat, lectus sit amet luctus vulputate, nisi sem semper erat, in consectetuer ipsum','2015-04-04 20:51:58','2016-05-14 05:32:41','2015-07-11 20:23:11',1,12,'53.63626','58.75086',1,1),(173,1,20,'eu','nec, malesuada ut, sem. Nulla interdum. Curabitur dictum. Phasellus in felis. Nulla tempor augue ac ipsum. Phasellus vitae mauris sit','2015-01-31 10:44:57','2016-05-23 05:32:12','2015-07-11 20:23:11',1,7,'-65.59873','-38.10935',1,1),(174,1,2,'tincidunt','mauris. Integer sem elit, pharetra ut, pharetra sed, hendrerit a, arcu. Sed et libero. Proin mi. Aliquam gravida mauris ut mi. Duis risus odio, auctor vitae, aliquet nec, imperdiet nec, leo. Morbi neque','2015-06-28 02:11:38','2016-04-02 13:39:50','2015-07-11 20:23:11',1,9,'29.04703','132.42856',1,1),(175,1,27,'eu arcu. Morbi','tellus. Phasellus elit pede, malesuada vel, venenatis vel, faucibus id, libero. Donec consectetuer mauris id sapien. Cras dolor dolor, tempus non, lacinia','2015-01-27 17:34:01','2016-07-30 08:28:32','2015-07-11 20:23:11',1,15,'60.07987','132.28167',1,1),(176,1,3,'magna sed','Proin velit. Sed malesuada augue ut lacus. Nulla tincidunt, neque vitae semper egestas, urna justo faucibus lectus, a sollicitudin orci sem','2015-05-10 12:57:51','2016-06-08 08:58:32','2015-07-11 20:23:11',1,8,'-86.15057','159.78217',1,1),(177,1,22,'ligula','eget, dictum placerat, augue. Sed molestie. Sed id risus quis diam luctus lobortis. Class aptent taciti sociosqu ad litora torquent per conubia nostra,','2015-01-16 22:15:41','2016-01-01 05:05:16','2015-07-11 20:23:11',1,4,'53.4971','-2.67871',1,1),(178,1,14,'arcu. Vestibulum','eu dui. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Aenean eget magna. Suspendisse tristique neque venenatis lacus. Etiam bibendum fermentum metus. Aenean sed pede nec ante blandit viverra. Donec tempus, lorem fringilla ornare placerat, orci lacus vestibulum lorem, sit amet ultricies sem magna nec','2015-04-11 21:25:31','2016-01-04 08:45:48','2015-07-11 20:23:11',1,5,'-18.07329','-138.05287',1,1),(179,1,31,'sem, consequat','diam nunc, ullamcorper eu, euismod ac, fermentum vel, mauris. Integer sem elit, pharetra ut, pharetra sed, hendrerit a, arcu. Sed et libero. Proin mi.','2015-05-03 11:56:33','2016-06-23 00:26:47','2015-07-11 20:23:11',1,14,'12.12644','127.82482',1,1),(180,1,25,'risus,','tellus. Aenean egestas hendrerit neque. In ornare sagittis felis. Donec tempor, est ac mattis semper, dui lectus rutrum urna, nec luctus felis purus ac tellus. Suspendisse sed dolor. Fusce mi lorem, vehicula et, rutrum eu, ultrices sit amet, risus. Donec nibh enim, gravida sit amet, dapibus id, blandit at,','2015-01-25 19:19:02','2016-07-25 15:28:15','2015-07-11 20:23:11',1,5,'-28.84482','172.22188',1,1),(181,1,10,'sapien molestie','Quisque porttitor eros nec tellus. Nunc lectus pede, ultrices a, auctor non, feugiat nec, diam. Duis mi enim, condimentum eget, volutpat ornare, facilisis eget, ipsum. Donec sollicitudin adipiscing ligula. Aenean gravida nunc sed pede. Cum sociis natoque penatibus et magnis dis','2015-06-12 21:42:09','2016-05-03 17:14:00','2015-07-11 20:23:11',1,4,'-73.56099','-67.73599',1,1),(182,1,11,'augue id','fames ac turpis egestas. Fusce aliquet magna a neque. Nullam ut nisi a odio semper cursus. Integer mollis. Integer tincidunt aliquam arcu. Aliquam ultrices iaculis odio. Nam interdum enim non nisi. Aenean eget metus. In nec orci. Donec nibh. Quisque nonummy ipsum non arcu. Vivamus sit amet risus.','2015-01-06 11:57:23','2016-06-02 08:04:45','2015-07-11 20:23:11',1,5,'-89.51328','-158.42912',1,1),(183,1,5,'purus sapien, gravida','scelerisque scelerisque dui. Suspendisse ac metus vitae velit egestas lacinia. Sed congue, elit sed consequat auctor, nunc nulla vulputate dui,','2015-03-26 05:03:36','2016-04-08 14:35:53','2015-07-11 20:23:11',1,8,'-47.83744','120.42455',1,1),(184,1,24,'diam','nibh lacinia orci, consectetuer euismod est arcu ac orci. Ut semper pretium neque. Morbi quis urna. Nunc quis arcu vel quam dignissim pharetra. Nam ac nulla. In tincidunt congue turpis. In condimentum. Donec at arcu. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia','2015-06-29 06:32:34','2016-02-18 01:05:47','2015-07-11 20:23:11',1,9,'-76.41478','37.98468',1,1),(185,1,4,'montes, nascetur','dui nec urna suscipit nonummy. Fusce fermentum fermentum arcu. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Phasellus ornare. Fusce mollis. Duis sit amet diam eu dolor egestas rhoncus. Proin nisl','2015-05-14 12:24:51','2016-03-13 15:24:44','2015-07-11 20:23:11',1,7,'62.66021','20.05938',1,1),(186,1,23,'nec enim.','dui. Fusce aliquam, enim nec tempus scelerisque, lorem ipsum sodales purus, in molestie tortor nibh sit amet orci. Ut sagittis','2015-04-05 22:18:24','2016-07-05 03:11:22','2015-07-11 20:23:11',1,10,'42.26974','17.2894',1,1),(187,1,7,'in','accumsan sed, facilisis vitae, orci. Phasellus dapibus quam quis diam. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Fusce aliquet magna a neque. Nullam ut nisi a odio semper cursus. Integer mollis. Integer tincidunt aliquam arcu. Aliquam ultrices iaculis odio. Nam interdum enim non nisi.','2015-02-04 10:40:58','2016-05-13 01:51:30','2015-07-11 20:23:11',1,11,'87.36158','-114.03084',1,1),(188,1,25,'vel, convallis in,','quam. Curabitur vel lectus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec dignissim magna a tortor. Nunc commodo auctor velit. Aliquam nisl. Nulla eu neque pellentesque massa lobortis ultrices. Vivamus rhoncus.','2015-01-16 22:24:42','2016-01-16 13:52:14','2015-07-11 20:23:11',1,13,'88.39128','42.55608',1,1),(189,1,26,'ac mattis ornare,','vitae velit egestas lacinia. Sed congue, elit sed consequat auctor, nunc nulla vulputate dui, nec tempus mauris erat eget ipsum. Suspendisse sagittis. Nullam vitae diam. Proin dolor. Nulla semper tellus id nunc interdum feugiat. Sed nec metus facilisis lorem tristique aliquet. Phasellus fermentum convallis ligula. Donec','2015-03-12 02:50:26','2016-04-02 11:57:56','2015-07-11 20:23:11',1,8,'55.89647','-99.25852',1,1),(190,1,17,'Cras eget','at, velit. Pellentesque ultricies dignissim lacus. Aliquam rutrum lorem ac risus. Morbi metus. Vivamus euismod urna. Nullam lobortis quam a felis ullamcorper viverra. Maecenas iaculis aliquet diam. Sed diam lorem, auctor quis, tristique ac,','2015-06-24 16:22:27','2016-05-20 14:19:33','2015-07-11 20:23:11',1,12,'-29.39226','-99.24544',1,1),(191,1,31,'Nunc','lectus convallis est, vitae sodales nisi magna sed dui. Fusce aliquam, enim nec tempus scelerisque, lorem ipsum sodales purus, in','2015-06-07 03:19:02','2016-04-28 23:27:12','2015-07-11 20:23:11',1,5,'19.86908','-65.27182',1,1),(192,1,11,'a, facilisis','mus. Proin vel nisl. Quisque fringilla euismod enim. Etiam gravida molestie arcu. Sed eu nibh vulputate mauris sagittis placerat. Cras dictum ultricies ligula.','2015-06-25 03:16:55','2016-01-10 22:50:53','2015-07-11 20:23:11',1,7,'-12.9728','7.87348',1,1),(193,1,21,'sodales at,','torquent per conubia nostra, per inceptos hymenaeos. Mauris ut quam vel sapien imperdiet ornare. In faucibus. Morbi vehicula. Pellentesque tincidunt tempus risus.','2015-06-08 22:48:19','2016-07-27 18:47:38','2015-07-11 20:23:11',1,14,'28.70952','168.49703',1,1),(194,1,25,'eleifend. Cras','iaculis aliquet diam. Sed diam lorem, auctor quis, tristique ac, eleifend vitae, erat. Vivamus nisi. Mauris nulla. Integer urna. Vivamus molestie dapibus ligula. Aliquam erat volutpat. Nulla dignissim. Maecenas ornare egestas ligula. Nullam feugiat placerat','2015-02-05 03:17:00','2016-04-20 07:25:04','2015-07-11 20:23:11',1,13,'-28.86881','-11.55774',1,1),(195,1,31,'est','adipiscing fringilla, porttitor vulputate, posuere vulputate, lacus. Cras interdum. Nunc sollicitudin commodo ipsum. Suspendisse non leo. Vivamus nibh dolor, nonummy ac, feugiat non, lobortis quis, pede. Suspendisse dui. Fusce diam nunc, ullamcorper eu, euismod ac, fermentum vel, mauris. Integer sem elit, pharetra ut, pharetra sed, hendrerit a, arcu.','2015-04-27 17:16:17','2016-01-26 02:45:46','2015-07-11 20:23:11',1,4,'-70.36583','-21.51684',1,1),(196,1,28,'orci. Ut semper','nunc interdum feugiat. Sed nec metus facilisis lorem tristique aliquet. Phasellus fermentum convallis ligula. Donec luctus aliquet odio. Etiam ligula tortor, dictum eu, placerat eget, venenatis a, magna. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Etiam laoreet, libero et tristique pellentesque,','2015-06-11 07:27:38','2016-07-07 16:02:08','2015-07-11 20:23:11',1,13,'-18.85003','-132.24252',1,1),(197,1,8,'dictum','nisi dictum augue malesuada malesuada. Integer id magna et ipsum cursus vestibulum. Mauris magna. Duis dignissim tempor arcu. Vestibulum ut eros non enim commodo hendrerit. Donec porttitor tellus non magna. Nam ligula elit, pretium et, rutrum non, hendrerit id, ante.','2015-03-08 07:07:22','2016-07-13 18:13:09','2015-07-11 20:23:11',1,5,'-67.28687','96.45414',1,1),(198,1,27,'Nunc pulvinar','pede, malesuada vel, venenatis vel, faucibus id, libero. Donec consectetuer mauris id sapien. Cras dolor dolor, tempus non, lacinia at, iaculis quis, pede. Praesent eu dui. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Aenean eget magna. Suspendisse tristique neque venenatis','2015-02-14 17:12:11','2016-01-20 18:03:18','2015-07-11 20:23:11',1,5,'-84.35219','38.99011',1,1),(199,1,4,'cursus, diam at','nibh lacinia orci, consectetuer euismod est arcu ac orci. Ut semper pretium neque. Morbi quis urna. Nunc quis arcu vel quam dignissim pharetra.','2015-06-13 05:29:37','2016-03-07 04:08:26','2015-07-11 20:23:11',1,14,'15.65438','145.95786',1,1),(200,1,18,'egestas. Fusce','ornare, libero at auctor ullamcorper, nisl arcu iaculis enim, sit amet ornare lectus justo eu arcu. Morbi sit amet massa. Quisque porttitor eros nec tellus. Nunc lectus pede, ultrices a, auctor non, feugiat nec, diam.','2015-06-19 22:41:21','2016-01-03 16:48:18','2015-07-11 20:23:11',1,4,'41.17688','-144.15411',1,1),(201,1,7,'Sed nec','penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec dignissim magna a tortor. Nunc commodo auctor velit. Aliquam nisl. Nulla eu neque pellentesque massa lobortis ultrices. Vivamus rhoncus. Donec est. Nunc ullamcorper, velit','2015-04-09 01:34:53','2016-04-06 06:30:53','2015-07-11 20:23:11',1,13,'43.24814','122.70066',1,1),(202,1,2,'nunc','molestie dapibus ligula. Aliquam erat volutpat. Nulla dignissim. Maecenas ornare egestas ligula. Nullam feugiat placerat velit. Quisque varius. Nam porttitor','2015-05-02 22:04:51','2016-02-12 15:34:22','2015-07-11 20:23:11',1,5,'23.47055','53.34183',1,1),(203,1,29,'Integer','velit dui, semper et, lacinia vitae, sodales at, velit. Pellentesque ultricies dignissim lacus. Aliquam rutrum lorem ac risus. Morbi metus. Vivamus euismod urna. Nullam lobortis quam','2015-06-25 23:00:00','2016-07-26 19:47:08','2015-07-11 20:23:11',1,4,'87.2931','30.45969',1,1),(204,1,8,'dictum mi, ac','magnis dis parturient montes, nascetur ridiculus mus. Proin vel nisl. Quisque fringilla euismod enim. Etiam gravida molestie arcu. Sed eu nibh vulputate mauris sagittis placerat. Cras dictum ultricies ligula. Nullam enim. Sed','2015-01-19 07:58:44','2016-06-14 13:42:15','2015-07-11 20:23:11',1,6,'58.37659','71.44017',1,1),(205,1,4,'tortor. Integer aliquam','lacinia orci, consectetuer euismod est arcu ac orci. Ut semper pretium neque. Morbi quis urna. Nunc quis arcu vel quam dignissim pharetra. Nam ac nulla. In tincidunt congue turpis. In condimentum. Donec at arcu. Vestibulum ante ipsum primis in faucibus orci luctus','2015-05-31 04:15:20','2016-02-03 22:55:21','2015-07-11 20:23:11',1,7,'68.94217','56.7029',1,1),(206,1,24,'pretium neque. Morbi','vitae, posuere at, velit. Cras lorem lorem, luctus ut, pellentesque eget, dictum placerat, augue. Sed molestie. Sed id risus quis diam luctus lobortis. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos','2015-01-29 22:22:14','2016-04-29 00:47:36','2015-07-11 20:23:11',1,12,'-78.76161','-104.15303',1,1),(207,1,1,'Promoção de teste','Promoçao de teste ilimitada 01','2015-01-29 22:22:14','2016-04-29 00:47:36','2015-07-12 14:26:33',0,0,'-78.76161','-104.15303',1,1),(208,1,2,'PRomoção de teste 02','PRomoção de teste ilimitada 02','2015-01-29 22:22:14','2016-04-29 00:47:36','2015-07-12 14:26:34',0,0,'-78.76161','-104.15303',1,1);
/*!40000 ALTER TABLE `promocao` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `promocaocategoria`
--

DROP TABLE IF EXISTS `promocaocategoria`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `promocaocategoria` (
  `categoria_procat` bigint(20) NOT NULL,
  `promocao_procat` bigint(20) NOT NULL,
  PRIMARY KEY (`categoria_procat`,`promocao_procat`),
  KEY `FK_PromocaoCategoria_Promocao_idx` (`promocao_procat`),
  CONSTRAINT `FK_PromocaoCategoria_Categoria` FOREIGN KEY (`categoria_procat`) REFERENCES `categoria` (`codigo_cat`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_PromocaoCategoria_Promocao` FOREIGN KEY (`promocao_procat`) REFERENCES `promocao` (`codigo_pro`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `promocaocategoria`
--

LOCK TABLES `promocaocategoria` WRITE;
/*!40000 ALTER TABLE `promocaocategoria` DISABLE KEYS */;
/*!40000 ALTER TABLE `promocaocategoria` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `promocaorequerida`
--

DROP TABLE IF EXISTS `promocaorequerida`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `promocaorequerida` (
  `codigo_proreq` bigint(20) NOT NULL AUTO_INCREMENT,
  `Promocao_codigo_proreq` bigint(20) NOT NULL,
  `codVoucher_proreq` varchar(40) NOT NULL COMMENT 'Regra para geração do Voucher\n1 - Quando promoção limitada, não importa o cliente que a gerou, o usuário app só pode ter um voucher ativo.\n2 - Quando promoção ilimitada, o usuário app pode ter vários voucher ativos, de clientes diferentes.',
  `validade_proreq` datetime NOT NULL COMMENT 'Se a promoção for limitada, o voucher valerá 24h. (data do cadastro + 24h)\nse a prompção for ilimitada, o voucher valerá até a data final da promoção. (Data final da promoção)',
  `datacad_proreq` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `userCloudId_proreq` varchar(100) NOT NULL,
  `status_proreq` tinyint(4) NOT NULL DEFAULT '0' COMMENT '0 - Em aberto\n1 - Utilizada\n2 - Expirada\n3 - Desistiu',
  `datastatus_proreq` datetime DEFAULT NULL COMMENT 'Data em que o status foi alterado (pelo usuário app ou automaticamente pelo sistema)',
  `foraregra_proreq` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`codigo_proreq`),
  KEY `fk_PromocaoRequerida_Promocao1_idx` (`Promocao_codigo_proreq`),
  CONSTRAINT `fk_PromocaoRequerida_Promocao1` FOREIGN KEY (`Promocao_codigo_proreq`) REFERENCES `promocao` (`codigo_pro`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=ujis;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `promocaorequerida`
--

LOCK TABLES `promocaorequerida` WRITE;
/*!40000 ALTER TABLE `promocaorequerida` DISABLE KEYS */;
INSERT INTO `promocaorequerida` VALUES (32,197,'20150727012155.197.32','2015-07-27 22:52:30','2015-07-26 01:21:56','557d99321b40070b89038887',0,'2015-07-26 22:52:30',0),(34,198,'20150727013606.198.34','2015-07-27 01:36:06','2015-07-26 01:36:06','557d99321b40070b89038887',3,'2015-07-26 13:18:35',0),(45,207,'20160429004736.207.45','2016-04-29 00:47:36','2015-07-26 22:27:19','557d99321b40070b89038887',0,'2015-07-26 22:27:19',0),(46,169,'20150727222812.169.46','2015-07-27 22:28:13','2015-07-26 22:28:12','557d99321b40070b89038887',3,'2015-07-26 22:28:32',0),(47,203,'20150727222852.203.47','2015-07-27 22:28:53','2015-07-26 22:28:52','557d99321b40070b89038887',3,'2015-07-26 22:28:57',0);
/*!40000 ALTER TABLE `promocaorequerida` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuario`
--

DROP TABLE IF EXISTS `usuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `usuario` (
  `codigo_usr` bigint(20) NOT NULL AUTO_INCREMENT,
  `login_usr` varchar(25) NOT NULL,
  `pw_usr` varchar(200) NOT NULL,
  `nome_usr` varchar(150) NOT NULL,
  `telefone_usr` varchar(20) NOT NULL,
  PRIMARY KEY (`codigo_usr`),
  UNIQUE KEY `login_usr_UNIQUE` (`login_usr`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuario`
--

LOCK TABLES `usuario` WRITE;
/*!40000 ALTER TABLE `usuario` DISABLE KEYS */;
INSERT INTO `usuario` VALUES (10,'cesantos','*23AE809DDACAF96AF0FD78ED04B6A265E05AA257','Carlos Eduardo Santos Alves Domingos','81543928'),(11,'walmer','*23AE809DDACAF96AF0FD78ED04B6A265E05AA257','Walmer','00000000'),(12,'fred','*23AE809DDACAF96AF0FD78ED04B6A265E05AA257','Frederiko','00000000');
/*!40000 ALTER TABLE `usuario` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2015-07-26 22:54:57
