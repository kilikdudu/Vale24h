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
  `dataalt_cat` datetime DEFAULT NULL,
  `usercad_cat` bigint(20) NOT NULL,
  `useralt_cat` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`codigo_cat`),
  KEY `FK_Categoria_UsuarioCad_idx` (`usercad_cat`),
  KEY `FK_Categoria_UsuarioAlt_idx` (`useralt_cat`),
  CONSTRAINT `FK_Categoria_UsuarioAlt` FOREIGN KEY (`useralt_cat`) REFERENCES `usuario` (`codigo_usr`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_Categoria_UsuarioCad` FOREIGN KEY (`usercad_cat`) REFERENCES `usuario` (`codigo_usr`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categoria`
--

LOCK TABLES `categoria` WRITE;
/*!40000 ALTER TABLE `categoria` DISABLE KEYS */;
INSERT INTO `categoria` VALUES (1,'Vestuário',1,'2015-06-13 22:41:52',NULL,1,NULL);
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
  `documento_cli` varchar(14) NOT NULL,
  `tipoDocumento_cli` tinyint(4) NOT NULL,
  `nomeFantasia_cli` varchar(100) DEFAULT NULL,
  `contato_cli` varchar(100) NOT NULL,
  `useralt_cli` bigint(20) DEFAULT NULL,
  `usercad_cli` bigint(20) NOT NULL,
  `datacad_cli` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `dataalt_cli` datetime DEFAULT NULL,
  `cloudId_cli` varchar(100) NOT NULL,
  `imagem_cli` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`codigo_cli`),
  UNIQUE KEY `cloudId_cli_UNIQUE` (`cloudId_cli`),
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
INSERT INTO `cliente` VALUES (1,'Hering','32513413000166',2,'Hering Store','Fernanda',NULL,1,'2015-06-13 22:47:00',NULL,'5560ee319797df08f8095147','logo.png');
/*!40000 ALTER TABLE `cliente` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `endereco`
--

DROP TABLE IF EXISTS `endereco`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `endereco` (
  `codigo_end` bigint(20) NOT NULL AUTO_INCREMENT,
  `codigoCli_end` bigint(20) NOT NULL,
  `ativo_end` tinyint(1) NOT NULL DEFAULT '1',
  `cep_end` varchar(8) NOT NULL,
  `logradouro_end` varchar(40) DEFAULT NULL,
  `numero_end` varchar(10) DEFAULT NULL,
  `referencia_end` varchar(30) DEFAULT NULL,
  `datacad_end` datetime DEFAULT CURRENT_TIMESTAMP,
  `usercad_end` bigint(20) NOT NULL,
  `useralt_end` bigint(20) DEFAULT NULL,
  `dataalt_end` datetime DEFAULT NULL,
  `latitude_end` varchar(20) DEFAULT NULL,
  `longitude_end` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`codigo_end`),
  KEY `FK_Endereco_Cliente_idx` (`codigoCli_end`),
  KEY `FK_Endereco_UsuarioCad_idx` (`usercad_end`),
  KEY `FK_Endereco_UsuarioAlt_idx` (`useralt_end`),
  CONSTRAINT `FK_Endereco_Cliente` FOREIGN KEY (`codigoCli_end`) REFERENCES `cliente` (`codigo_cli`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_Endereco_UsuarioAlt` FOREIGN KEY (`useralt_end`) REFERENCES `usuario` (`codigo_usr`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_Endereco_UsuarioCad` FOREIGN KEY (`usercad_end`) REFERENCES `usuario` (`codigo_usr`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `endereco`
--

LOCK TABLES `endereco` WRITE;
/*!40000 ALTER TABLE `endereco` DISABLE KEYS */;
/*!40000 ALTER TABLE `endereco` ENABLE KEYS */;
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
  PRIMARY KEY (`codigo_img`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `imagem`
--

LOCK TABLES `imagem` WRITE;
/*!40000 ALTER TABLE `imagem` DISABLE KEYS */;
INSERT INTO `imagem` VALUES (1,'promocao1.jpg'),(2,'roupas.jpg'),(3,'roupas2.jpg');
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
  `titulo_pro` varchar(30) NOT NULL,
  `descricao_pro` varchar(150) NOT NULL,
  `imagem_pro` bigint(20) DEFAULT NULL,
  `inicio_pro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fim_pro` datetime NOT NULL,
  `totalTickets_pro` int(11) NOT NULL,
  `ticketsAlocados_pro` int(11) NOT NULL DEFAULT '0',
  `limitada_pro` tinyint(1) NOT NULL DEFAULT '1',
  `cliente_pro` bigint(20) NOT NULL,
  `latitude_pro` varchar(20) NOT NULL,
  `longitude_pro` varchar(20) NOT NULL,
  PRIMARY KEY (`codigo_pro`),
  KEY `FK_Promocao_Cliente_idx` (`cliente_pro`),
  KEY `FK_Promocao_Imagem_idx` (`imagem_pro`),
  CONSTRAINT `FK_Promocao_Cliente` FOREIGN KEY (`cliente_pro`) REFERENCES `cliente` (`codigo_cli`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_Promocao_Imagem` FOREIGN KEY (`imagem_pro`) REFERENCES `imagem` (`codigo_img`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `promocao`
--

LOCK TABLES `promocao` WRITE;
/*!40000 ALTER TABLE `promocao` DISABLE KEYS */;
INSERT INTO `promocao` VALUES (2,'Promoção de teste','Essa é uma promoção de teste, caso tudo ocorra bem, este aplicativo será bem sucedido. Enrolando com mais alguns caracteres !',1,'2015-07-04 00:00:00','2015-08-30 00:00:00',10,0,1,1,' -16.673154',' -49.257166'),(3,'Venha pegar','Venha pegar uma peça de roupa quase de graça.',2,'2015-07-04 00:00:00','2015-08-30 00:00:00',3,0,1,1,' -16.673154',' -49.257166'),(4,'Comemore isto','Venha comemorar nosso aniversário, pegando este ticket você ganha 20% de desconto em qualquer roupa',3,'2015-07-04 00:00:00','2015-07-11 00:00:00',0,0,0,1,' -16.673154',' -49.257166');
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
  `promocao_proreq` bigint(20) NOT NULL,
  `validade_proreq` datetime DEFAULT NULL,
  `datacad_proreq` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `userCloudId_proreq` varchar(100) NOT NULL,
  `codVoucher_proreq` varchar(40) NOT NULL,
  `ativa_proreq` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`codigo_proreq`),
  KEY `FK_PromocaoRequerida_Promocao_idx` (`promocao_proreq`),
  CONSTRAINT `FK_PromocaoRequerida_Promocao` FOREIGN KEY (`promocao_proreq`) REFERENCES `promocao` (`codigo_pro`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=ujis;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `promocaorequerida`
--

LOCK TABLES `promocaorequerida` WRITE;
/*!40000 ALTER TABLE `promocaorequerida` DISABLE KEYS */;
/*!40000 ALTER TABLE `promocaorequerida` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `telefone`
--

DROP TABLE IF EXISTS `telefone`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `telefone` (
  `codigo_tel` bigint(20) NOT NULL AUTO_INCREMENT,
  `codigoCli_tel` bigint(20) NOT NULL,
  `ddd_tel` varchar(2) NOT NULL,
  `fone_tel` varchar(18) NOT NULL,
  `tipofone_tel` tinyint(4) NOT NULL DEFAULT '0',
  `contato_tel` varchar(45) DEFAULT NULL,
  `datacad_tel` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `dataalt_tel` datetime DEFAULT NULL,
  `usercad_tel` bigint(20) NOT NULL,
  `useralt_tel` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`codigo_tel`),
  KEY `FK_Telefone_Cliente_idx` (`codigoCli_tel`),
  KEY `FK_Telefone_UsuarioCad_idx` (`usercad_tel`),
  KEY `FK_Telefone_UsuarioAlt_idx` (`useralt_tel`),
  CONSTRAINT `FK_Telefone_Cliente` FOREIGN KEY (`codigoCli_tel`) REFERENCES `cliente` (`codigo_cli`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_Telefone_UsuarioAlt` FOREIGN KEY (`useralt_tel`) REFERENCES `usuario` (`codigo_usr`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_Telefone_UsuarioCad` FOREIGN KEY (`usercad_tel`) REFERENCES `usuario` (`codigo_usr`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `telefone`
--

LOCK TABLES `telefone` WRITE;
/*!40000 ALTER TABLE `telefone` DISABLE KEYS */;
/*!40000 ALTER TABLE `telefone` ENABLE KEYS */;
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
  `codigoTel_usr` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`codigo_usr`),
  UNIQUE KEY `login_usr_UNIQUE` (`login_usr`),
  UNIQUE KEY `pw_usr_UNIQUE` (`pw_usr`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuario`
--

LOCK TABLES `usuario` WRITE;
/*!40000 ALTER TABLE `usuario` DISABLE KEYS */;
INSERT INTO `usuario` VALUES (1,'root','*6BB4837EB74329105EE4568DDA7DC67ED2CA2AD9','Carlos Eduardo',NULL);
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

-- Dump completed on 2015-07-07  1:23:38
