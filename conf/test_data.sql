CREATE DATABASE  IF NOT EXISTS `mmcp` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `mmcp`;
-- MySQL dump 10.13  Distrib 5.6.18, for Win32 (x86)
--
-- Host: localhost    Database: mmcp
-- ------------------------------------------------------
-- Server version	5.6.19-enterprise-commercial-advanced

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
-- Table structure for table `auth_group`
--

DROP TABLE IF EXISTS `auth_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(80) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group`
--

LOCK TABLES `auth_group` WRITE;
/*!40000 ALTER TABLE `auth_group` DISABLE KEYS */;
INSERT INTO `auth_group` VALUES (3,'副总经理'),(8,'工程部门'),(2,'总经理'),(7,'财务部门'),(4,'财务部门经理'),(9,'采购部门'),(5,'采购部门经理'),(10,'预算部门'),(6,'预算部门经理');
/*!40000 ALTER TABLE `auth_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group_permissions`
--

DROP TABLE IF EXISTS `auth_group_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_group_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `group_id` (`group_id`,`permission_id`),
  KEY `auth_group_permissions_5f412f9a` (`group_id`),
  KEY `auth_group_permissions_83d7f98b` (`permission_id`),
  CONSTRAINT `group_id_refs_id_f4b32aac` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `permission_id_refs_id_6ba0f519` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group_permissions`
--

LOCK TABLES `auth_group_permissions` WRITE;
/*!40000 ALTER TABLE `auth_group_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_permission`
--

DROP TABLE IF EXISTS `auth_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_permission` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `content_type_id` (`content_type_id`,`codename`),
  KEY `auth_permission_37ef4eb4` (`content_type_id`),
  CONSTRAINT `content_type_id_refs_id_d043b34a` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=85 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add permission',1,'add_permission'),(2,'Can change permission',1,'change_permission'),(3,'Can delete permission',1,'delete_permission'),(4,'Can add group',2,'add_group'),(5,'Can change group',2,'change_group'),(6,'Can delete group',2,'delete_group'),(7,'Can view group',2,'view_group'),(8,'Can view permission',1,'view_permission'),(9,'Can add content type',3,'add_contenttype'),(10,'Can change content type',3,'change_contenttype'),(11,'Can delete content type',3,'delete_contenttype'),(12,'Can view content type',3,'view_contenttype'),(13,'Can add session',4,'add_session'),(14,'Can change session',4,'change_session'),(15,'Can delete session',4,'delete_session'),(16,'Can view session',4,'view_session'),(17,'Can add site',5,'add_site'),(18,'Can change site',5,'change_site'),(19,'Can delete site',5,'delete_site'),(20,'Can view site',5,'view_site'),(21,'Can add revision',6,'add_revision'),(22,'Can change revision',6,'change_revision'),(23,'Can delete revision',6,'delete_revision'),(24,'Can add version',7,'add_version'),(25,'Can change version',7,'change_version'),(26,'Can delete version',7,'delete_version'),(27,'Can view revision',6,'view_revision'),(28,'Can view version',7,'view_version'),(29,'Can add 公司',8,'add_company'),(30,'Can change 公司',8,'change_company'),(31,'Can delete 公司',8,'delete_company'),(32,'Can add user',9,'add_employee'),(33,'Can change user',9,'change_employee'),(34,'Can delete user',9,'delete_employee'),(35,'Can view user',9,'view_employee'),(36,'Can view 公司',8,'view_company'),(37,'Can add 类别',10,'add_category'),(38,'Can change 类别',10,'change_category'),(39,'Can delete 类别',10,'delete_category'),(40,'Can add 规格',11,'add_specification'),(41,'Can change 规格',11,'change_specification'),(42,'Can delete 规格',11,'delete_specification'),(43,'Can add 单位',12,'add_unit'),(44,'Can change 单位',12,'change_unit'),(45,'Can delete 单位',12,'delete_unit'),(46,'Can add 材料',13,'add_material'),(47,'Can change 材料',13,'change_material'),(48,'Can delete 材料',13,'delete_material'),(49,'Can add 品牌',14,'add_brand'),(50,'Can change 品牌',14,'change_brand'),(51,'Can delete 品牌',14,'delete_brand'),(52,'Can add 供应商',15,'add_vendor'),(53,'Can change 供应商',15,'change_vendor'),(54,'Can delete 供应商',15,'delete_vendor'),(55,'Can view 供应商',15,'view_vendor'),(56,'Can view 单位',12,'view_unit'),(57,'Can view 品牌',14,'view_brand'),(58,'Can view 材料',13,'view_material'),(59,'Can view 类别',10,'view_category'),(60,'Can view 规格',11,'view_specification'),(61,'Can add 项目',16,'add_project'),(62,'Can change 项目',16,'change_project'),(63,'Can delete 项目',16,'delete_project'),(64,'Can add 项目材料',17,'add_projectmaterial'),(65,'Can change 项目材料',17,'change_projectmaterial'),(66,'Can delete 项目材料',17,'delete_projectmaterial'),(67,'Can add 材料选择',18,'add_selectedlineitem'),(68,'Can change 材料选择',18,'change_selectedlineitem'),(69,'Can delete 材料选择',18,'delete_selectedlineitem'),(70,'Can view 材料选择',18,'view_selectedlineitem'),(71,'Can view 项目',16,'view_project'),(72,'Can view 项目材料',17,'view_projectmaterial'),(73,'Can add Bookmark',19,'add_bookmark'),(74,'Can change Bookmark',19,'change_bookmark'),(75,'Can delete Bookmark',19,'delete_bookmark'),(76,'Can add User Setting',20,'add_usersettings'),(77,'Can change User Setting',20,'change_usersettings'),(78,'Can delete User Setting',20,'delete_usersettings'),(79,'Can add User Widget',21,'add_userwidget'),(80,'Can change User Widget',21,'change_userwidget'),(81,'Can delete User Widget',21,'delete_userwidget'),(82,'Can add 部门',22,'add_companygroup'),(83,'Can change 部门',22,'change_companygroup'),(84,'Can delete 部门',22,'delete_companygroup');
/*!40000 ALTER TABLE `auth_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user`
--

DROP TABLE IF EXISTS `auth_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_user` (
  `id` int(11) NOT NULL,
  `password` varchar(128) NOT NULL,
  `last_login` datetime NOT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(30) NOT NULL,
  `first_name` varchar(30) NOT NULL,
  `last_name` varchar(30) NOT NULL,
  `email` varchar(75) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user`
--

LOCK TABLES `auth_user` WRITE;
/*!40000 ALTER TABLE `auth_user` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `company_company`
--

DROP TABLE IF EXISTS `company_company`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `company_company` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) DEFAULT NULL,
  `name` varchar(50) NOT NULL,
  `short_name` varchar(50) NOT NULL,
  `address` varchar(50) NOT NULL,
  `phone` varchar(50) NOT NULL,
  `fax` varchar(50) NOT NULL,
  `zip` varchar(50) NOT NULL,
  `lft` int(10) unsigned NOT NULL,
  `rght` int(10) unsigned NOT NULL,
  `tree_id` int(10) unsigned NOT NULL,
  `level` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `company_company_410d0aac` (`parent_id`),
  KEY `company_company_329f6fb3` (`lft`),
  KEY `company_company_e763210f` (`rght`),
  KEY `company_company_ba470c4a` (`tree_id`),
  KEY `company_company_20e079f4` (`level`),
  CONSTRAINT `parent_id_refs_id_d95e7d2a` FOREIGN KEY (`parent_id`) REFERENCES `company_company` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `company_company`
--

LOCK TABLES `company_company` WRITE;
/*!40000 ALTER TABLE `company_company` DISABLE KEYS */;
INSERT INTO `company_company` VALUES (1,NULL,'合和','合和','合和','13800000','13800000','552100',1,2,1,0),(2,NULL,'南消','南消','南消','138000','138000','521000',1,2,2,0);
/*!40000 ALTER TABLE `company_company` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `company_employee`
--

DROP TABLE IF EXISTS `company_employee`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `company_employee` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `password` varchar(128) NOT NULL,
  `last_login` datetime NOT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(30) NOT NULL,
  `first_name` varchar(30) NOT NULL,
  `last_name` varchar(30) NOT NULL,
  `email` varchar(75) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime NOT NULL,
  `company_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  KEY `company_employee_0316dde1` (`company_id`),
  CONSTRAINT `company_id_refs_id_a708cab2` FOREIGN KEY (`company_id`) REFERENCES `company_company` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `company_employee`
--

LOCK TABLES `company_employee` WRITE;
/*!40000 ALTER TABLE `company_employee` DISABLE KEYS */;
INSERT INTO `company_employee` VALUES (1,'pbkdf2_sha256$12000$5hSphBuKoqMD$517+Ql4k3FImY54W+9eJlm2W85h7kF6B+S+kEf5WRLA=','2015-11-02 12:34:20',1,'admin','','','admin@mgrai.com',1,1,'2015-11-02 12:32:12',NULL),(2,'pbkdf2_sha256$12000$ib4eGFViMHGW$lpMxjxt6ZeOIqAyu88J/a7YLmHwZ/x/hDwYRizU9HyE=','2015-11-02 13:30:17',0,'bob','','','',1,1,'2015-11-02 13:25:56',1),(3,'pbkdf2_sha256$12000$FjH3AqEwnwtH$z7GD/Trk1CWz0hVP/5zRFRB2G+Y1fmVbJD6YiqmR1Ag=','2015-11-02 13:26:20',0,'jason','','','',1,1,'2015-11-02 13:26:20',2),(4,'pbkdf2_sha256$12000$BRoVyLO1iR2c$S5iLd1QucWo2IzG7+aoOTbhPsZcjkBW2VuBjCF5VOUo=','2015-11-02 13:39:51',0,'alex','','','',1,1,'2015-11-02 13:39:51',1),(5,'pbkdf2_sha256$12000$ymdPl4xxaWZh$mXCqHxFbU/5RGXzVQl5dQ3wSLQe4Kyy4qLg6tf8kj3Y=','2015-11-02 13:40:23',0,'ray','','ray','',1,1,'2015-11-02 13:40:23',1),(6,'pbkdf2_sha256$12000$57mVq6OiGAos$klJogc7+8unpiP6CMGuTV95A3kxO10j3/Df4TllL4wU=','2015-11-02 13:40:34',0,'zeal','','zeal','',1,1,'2015-11-02 13:40:34',1),(7,'pbkdf2_sha256$12000$SoTaXqoRRQ7n$J3YOTgbSApJN6jSN9ORheJxRAWmNf0DZTShIQDLV3vA=','2015-11-02 13:40:45',0,'jack','','jack','',1,1,'2015-11-02 13:40:45',1),(8,'pbkdf2_sha256$12000$J5tnLW7moh0j$okx4j/NGHF0kto0xUsFucrNc2tlbSwnQPmjR+52lGA4=','2015-11-02 13:40:53',0,'tom','','tom','',1,1,'2015-11-02 13:40:53',1),(9,'pbkdf2_sha256$12000$Dg5kH65nmZIL$rSGHyvBOr5VnWdFGqC4Kbjzze2Jq61n5QlENFqzo3wQ=','2015-11-02 13:41:03',0,'jeff','','jeff','',1,1,'2015-11-02 13:41:03',1);
/*!40000 ALTER TABLE `company_employee` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `company_employee_groups`
--

DROP TABLE IF EXISTS `company_employee_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `company_employee_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `employee_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `employee_id` (`employee_id`,`group_id`),
  KEY `company_employee_groups_5b3073ae` (`employee_id`),
  KEY `company_employee_groups_5f412f9a` (`group_id`),
  CONSTRAINT `employee_id_refs_id_da54842a` FOREIGN KEY (`employee_id`) REFERENCES `company_employee` (`id`),
  CONSTRAINT `group_id_refs_id_f88d5df1` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `company_employee_groups`
--

LOCK TABLES `company_employee_groups` WRITE;
/*!40000 ALTER TABLE `company_employee_groups` DISABLE KEYS */;
INSERT INTO `company_employee_groups` VALUES (1,4,8),(13,5,6),(12,5,10),(15,6,9),(11,7,7),(14,8,2),(10,9,3);
/*!40000 ALTER TABLE `company_employee_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `company_employee_user_permissions`
--

DROP TABLE IF EXISTS `company_employee_user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `company_employee_user_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `employee_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `employee_id` (`employee_id`,`permission_id`),
  KEY `company_employee_user_permissions_5b3073ae` (`employee_id`),
  KEY `company_employee_user_permissions_83d7f98b` (`permission_id`),
  CONSTRAINT `employee_id_refs_id_1364f6f6` FOREIGN KEY (`employee_id`) REFERENCES `company_employee` (`id`),
  CONSTRAINT `permission_id_refs_id_e45c7e40` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=79 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `company_employee_user_permissions`
--

LOCK TABLES `company_employee_user_permissions` WRITE;
/*!40000 ALTER TABLE `company_employee_user_permissions` DISABLE KEYS */;
INSERT INTO `company_employee_user_permissions` VALUES (1,2,1),(2,2,4),(3,2,5),(4,2,6),(5,2,7),(6,2,8),(7,2,9),(8,2,10),(9,2,11),(10,2,12),(11,2,13),(12,2,14),(13,2,15),(14,2,16),(15,2,17),(16,2,18),(17,2,19),(18,2,20),(19,2,21),(20,2,22),(21,2,23),(22,2,24),(23,2,25),(24,2,26),(25,2,27),(26,2,28),(27,2,32),(28,2,33),(29,2,34),(30,2,35),(31,2,37),(32,2,38),(33,2,39),(34,2,40),(35,2,41),(36,2,42),(37,2,43),(38,2,44),(39,2,45),(40,2,46),(41,2,47),(42,2,48),(43,2,49),(44,2,50),(45,2,51),(46,2,52),(47,2,53),(48,2,54),(49,2,55),(50,2,56),(51,2,57),(52,2,58),(53,2,59),(54,2,60),(55,2,61),(56,2,62),(57,2,63),(58,2,64),(59,2,65),(60,2,66),(61,2,67),(62,2,68),(63,2,69),(64,2,70),(65,2,71),(66,2,72),(67,2,73),(68,2,74),(69,2,75),(70,2,76),(71,2,77),(72,2,78),(73,2,79),(74,2,80),(75,2,81),(76,2,82),(77,2,83),(78,2,84);
/*!40000 ALTER TABLE `company_employee_user_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_content_type`
--

DROP TABLE IF EXISTS `django_content_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_content_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `app_label` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (1,'permission','auth','permission'),(2,'group','auth','group'),(3,'content type','contenttypes','contenttype'),(4,'session','sessions','session'),(5,'site','sites','site'),(6,'revision','reversion','revision'),(7,'version','reversion','version'),(8,'公司','company','company'),(9,'user','company','employee'),(10,'类别','material','category'),(11,'规格','material','specification'),(12,'单位','material','unit'),(13,'材料','material','material'),(14,'品牌','material','brand'),(15,'供应商','material','vendor'),(16,'项目','project','project'),(17,'项目材料','project','projectmaterial'),(18,'材料选择','project','selectedlineitem'),(19,'Bookmark','xadmin','bookmark'),(20,'User Setting','xadmin','usersettings'),(21,'User Widget','xadmin','userwidget'),(22,'部门','xadmin','companygroup');
/*!40000 ALTER TABLE `django_content_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_session`
--

DROP TABLE IF EXISTS `django_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_b7b81f0c` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_session`
--

LOCK TABLES `django_session` WRITE;
/*!40000 ALTER TABLE `django_session` DISABLE KEYS */;
INSERT INTO `django_session` VALUES ('t60o2y8kw1ksj910n9ezex7hupqq7n6v','MmQ2MDIwNWY0Y2YwMDJkM2U2MWM2ZDdiMjBjNzgwNGI4MDZiNjlhMDp7IkxJU1RfUVVFUlkiOltbImNvbXBhbnkiLCJlbXBsb3llZSJdLCImX3FfPWomX2NvbHM9aWQuX19zdHJfXyZwPTAmXz0xNDQ2NDcyMzQ3OTQxIl0sIl9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9pZCI6Miwid2l6YXJkX3Byb2plY3Rwcm9qZWN0X2FkbWluX3dpemFyZF9mb3JtX3BsdWdpbiI6eyJzdGVwX2ZpbGVzIjp7fSwic3RlcCI6Ilx1OTg3OVx1NzZlZVx1NzI3OVx1NWY4MSIsImV4dHJhX2RhdGEiOnt9LCJzdGVwX2RhdGEiOnt9fX0=','2015-11-16 13:52:37');
/*!40000 ALTER TABLE `django_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_site`
--

DROP TABLE IF EXISTS `django_site`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_site` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `domain` varchar(100) NOT NULL,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_site`
--

LOCK TABLES `django_site` WRITE;
/*!40000 ALTER TABLE `django_site` DISABLE KEYS */;
INSERT INTO `django_site` VALUES (1,'example.com','example.com');
/*!40000 ALTER TABLE `django_site` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `material_brand`
--

DROP TABLE IF EXISTS `material_brand`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `material_brand` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `material_brand`
--

LOCK TABLES `material_brand` WRITE;
/*!40000 ALTER TABLE `material_brand` DISABLE KEYS */;
/*!40000 ALTER TABLE `material_brand` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `material_category`
--

DROP TABLE IF EXISTS `material_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `material_category` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `material_category`
--

LOCK TABLES `material_category` WRITE;
/*!40000 ALTER TABLE `material_category` DISABLE KEYS */;
/*!40000 ALTER TABLE `material_category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `material_material`
--

DROP TABLE IF EXISTS `material_material`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `material_material` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `alias` varchar(150) DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  `specification` varchar(250) DEFAULT NULL,
  `unit_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `material_material_6f33f001` (`category_id`),
  KEY `material_material_b9dcc52b` (`unit_id`),
  CONSTRAINT `category_id_refs_id_5acf0bf5` FOREIGN KEY (`category_id`) REFERENCES `material_category` (`id`),
  CONSTRAINT `unit_id_refs_id_43092818` FOREIGN KEY (`unit_id`) REFERENCES `material_unit` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `material_material`
--

LOCK TABLES `material_material` WRITE;
/*!40000 ALTER TABLE `material_material` DISABLE KEYS */;
/*!40000 ALTER TABLE `material_material` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `material_specification`
--

DROP TABLE IF EXISTS `material_specification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `material_specification` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(250) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `material_specification`
--

LOCK TABLES `material_specification` WRITE;
/*!40000 ALTER TABLE `material_specification` DISABLE KEYS */;
/*!40000 ALTER TABLE `material_specification` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `material_unit`
--

DROP TABLE IF EXISTS `material_unit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `material_unit` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `material_unit`
--

LOCK TABLES `material_unit` WRITE;
/*!40000 ALTER TABLE `material_unit` DISABLE KEYS */;
/*!40000 ALTER TABLE `material_unit` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `material_vendor`
--

DROP TABLE IF EXISTS `material_vendor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `material_vendor` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) DEFAULT NULL,
  `name` varchar(50) NOT NULL,
  `short_name` varchar(50) DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  `company_id` int(11) DEFAULT NULL,
  `contact` varchar(50) DEFAULT NULL,
  `cellphone` varchar(50) DEFAULT NULL,
  `telephone` varchar(50) DEFAULT NULL,
  `fax` varchar(50) DEFAULT NULL,
  `email` varchar(75) DEFAULT NULL,
  `address` varchar(50) DEFAULT NULL,
  `website` varchar(50) DEFAULT NULL,
  `bank` varchar(50) DEFAULT NULL,
  `account` varchar(50) DEFAULT NULL,
  `business_area` longtext,
  `comments` longtext,
  `lft` int(10) unsigned NOT NULL,
  `rght` int(10) unsigned NOT NULL,
  `tree_id` int(10) unsigned NOT NULL,
  `level` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `material_vendor_410d0aac` (`parent_id`),
  KEY `material_vendor_6f33f001` (`category_id`),
  KEY `material_vendor_0316dde1` (`company_id`),
  KEY `material_vendor_329f6fb3` (`lft`),
  KEY `material_vendor_e763210f` (`rght`),
  KEY `material_vendor_ba470c4a` (`tree_id`),
  KEY `material_vendor_20e079f4` (`level`),
  CONSTRAINT `parent_id_refs_id_fd4d7a4c` FOREIGN KEY (`parent_id`) REFERENCES `material_vendor` (`id`),
  CONSTRAINT `category_id_refs_id_d13fce6c` FOREIGN KEY (`category_id`) REFERENCES `material_category` (`id`),
  CONSTRAINT `company_id_refs_id_7357d25d` FOREIGN KEY (`company_id`) REFERENCES `company_company` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `material_vendor`
--

LOCK TABLES `material_vendor` WRITE;
/*!40000 ALTER TABLE `material_vendor` DISABLE KEYS */;
/*!40000 ALTER TABLE `material_vendor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `project_project`
--

DROP TABLE IF EXISTS `project_project`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `project_project` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `short_name` varchar(50) DEFAULT NULL,
  `company_id` int(11) NOT NULL,
  `construct_unit` varchar(50) DEFAULT NULL,
  `property` varchar(50) DEFAULT NULL,
  `scale` varchar(50) DEFAULT NULL,
  `estimate_user_id` int(11) NOT NULL,
  `amount` decimal(15,2) DEFAULT NULL,
  `material_amount` decimal(15,2) DEFAULT NULL,
  `contract_format` varchar(50) DEFAULT NULL,
  `payment_type` longtext,
  `bid_date` date DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `settlement_method` varchar(50) DEFAULT NULL,
  `settlement_amount` decimal(15,2) DEFAULT NULL,
  `file` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `project_project_0316dde1` (`company_id`),
  KEY `project_project_f1510dd8` (`estimate_user_id`),
  CONSTRAINT `estimate_user_id_refs_id_614fcf95` FOREIGN KEY (`estimate_user_id`) REFERENCES `company_employee` (`id`),
  CONSTRAINT `company_id_refs_id_7850acf1` FOREIGN KEY (`company_id`) REFERENCES `company_company` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project_project`
--

LOCK TABLES `project_project` WRITE;
/*!40000 ALTER TABLE `project_project` DISABLE KEYS */;
/*!40000 ALTER TABLE `project_project` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `project_project_users`
--

DROP TABLE IF EXISTS `project_project_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `project_project_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL,
  `employee_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `project_id` (`project_id`,`employee_id`),
  KEY `project_project_users_37952554` (`project_id`),
  KEY `project_project_users_5b3073ae` (`employee_id`),
  CONSTRAINT `project_id_refs_id_64cedd69` FOREIGN KEY (`project_id`) REFERENCES `project_project` (`id`),
  CONSTRAINT `employee_id_refs_id_296e7dbe` FOREIGN KEY (`employee_id`) REFERENCES `company_employee` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project_project_users`
--

LOCK TABLES `project_project_users` WRITE;
/*!40000 ALTER TABLE `project_project_users` DISABLE KEYS */;
/*!40000 ALTER TABLE `project_project_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `project_projectmaterial`
--

DROP TABLE IF EXISTS `project_projectmaterial`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `project_projectmaterial` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL,
  `category_id` int(11) DEFAULT NULL,
  `material_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `price` decimal(15,2) DEFAULT NULL,
  `total` decimal(15,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `project_projectmaterial_37952554` (`project_id`),
  KEY `project_projectmaterial_6f33f001` (`category_id`),
  KEY `project_projectmaterial_f6ab4be3` (`material_id`),
  CONSTRAINT `project_id_refs_id_445896f6` FOREIGN KEY (`project_id`) REFERENCES `project_project` (`id`),
  CONSTRAINT `category_id_refs_id_9267cf2d` FOREIGN KEY (`category_id`) REFERENCES `material_category` (`id`),
  CONSTRAINT `material_id_refs_id_3972f73a` FOREIGN KEY (`material_id`) REFERENCES `material_material` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project_projectmaterial`
--

LOCK TABLES `project_projectmaterial` WRITE;
/*!40000 ALTER TABLE `project_projectmaterial` DISABLE KEYS */;
/*!40000 ALTER TABLE `project_projectmaterial` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `project_selectedlineitem`
--

DROP TABLE IF EXISTS `project_selectedlineitem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `project_selectedlineitem` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `projectMaterial_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `project_selectedlineitem_271e2461` (`projectMaterial_id`),
  KEY `project_selectedlineitem_6340c63c` (`user_id`),
  CONSTRAINT `user_id_refs_id_b178f144` FOREIGN KEY (`user_id`) REFERENCES `company_employee` (`id`),
  CONSTRAINT `projectMaterial_id_refs_id_7cb77362` FOREIGN KEY (`projectMaterial_id`) REFERENCES `project_projectmaterial` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project_selectedlineitem`
--

LOCK TABLES `project_selectedlineitem` WRITE;
/*!40000 ALTER TABLE `project_selectedlineitem` DISABLE KEYS */;
/*!40000 ALTER TABLE `project_selectedlineitem` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reversion_revision`
--

DROP TABLE IF EXISTS `reversion_revision`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reversion_revision` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `manager_slug` varchar(200) NOT NULL,
  `date_created` datetime NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `comment` longtext NOT NULL,
  PRIMARY KEY (`id`),
  KEY `reversion_revision_86395673` (`manager_slug`),
  KEY `reversion_revision_816e0180` (`date_created`),
  KEY `reversion_revision_6340c63c` (`user_id`),
  CONSTRAINT `user_id_refs_id_b2ae58f7` FOREIGN KEY (`user_id`) REFERENCES `company_employee` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reversion_revision`
--

LOCK TABLES `reversion_revision` WRITE;
/*!40000 ALTER TABLE `reversion_revision` DISABLE KEYS */;
/*!40000 ALTER TABLE `reversion_revision` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reversion_version`
--

DROP TABLE IF EXISTS `reversion_version`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reversion_version` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `revision_id` int(11) NOT NULL,
  `object_id` longtext NOT NULL,
  `object_id_int` int(11) DEFAULT NULL,
  `content_type_id` int(11) NOT NULL,
  `format` varchar(255) NOT NULL,
  `serialized_data` longtext NOT NULL,
  `object_repr` longtext NOT NULL,
  PRIMARY KEY (`id`),
  KEY `reversion_version_0c5c14b2` (`revision_id`),
  KEY `reversion_version_33b489b4` (`object_id_int`),
  KEY `reversion_version_37ef4eb4` (`content_type_id`),
  CONSTRAINT `content_type_id_refs_id_f5dce86c` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `revision_id_refs_id_a685e913` FOREIGN KEY (`revision_id`) REFERENCES `reversion_revision` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reversion_version`
--

LOCK TABLES `reversion_version` WRITE;
/*!40000 ALTER TABLE `reversion_version` DISABLE KEYS */;
/*!40000 ALTER TABLE `reversion_version` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `xadmin_bookmark`
--

DROP TABLE IF EXISTS `xadmin_bookmark`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `xadmin_bookmark` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(128) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `url_name` varchar(64) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `query` varchar(1000) NOT NULL,
  `is_share` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `xadmin_bookmark_6340c63c` (`user_id`),
  KEY `xadmin_bookmark_37ef4eb4` (`content_type_id`),
  CONSTRAINT `user_id_refs_id_fc7bfe39` FOREIGN KEY (`user_id`) REFERENCES `company_employee` (`id`),
  CONSTRAINT `content_type_id_refs_id_af66fd92` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `xadmin_bookmark`
--

LOCK TABLES `xadmin_bookmark` WRITE;
/*!40000 ALTER TABLE `xadmin_bookmark` DISABLE KEYS */;
/*!40000 ALTER TABLE `xadmin_bookmark` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `xadmin_companygroup`
--

DROP TABLE IF EXISTS `xadmin_companygroup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `xadmin_companygroup` (
  `group_ptr_id` int(11) NOT NULL,
  `company_id` int(11) NOT NULL,
  PRIMARY KEY (`group_ptr_id`),
  KEY `xadmin_companygroup_0316dde1` (`company_id`),
  CONSTRAINT `company_id_refs_id_88125bed` FOREIGN KEY (`company_id`) REFERENCES `company_company` (`id`),
  CONSTRAINT `group_ptr_id_refs_id_f496f25a` FOREIGN KEY (`group_ptr_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `xadmin_companygroup`
--

LOCK TABLES `xadmin_companygroup` WRITE;
/*!40000 ALTER TABLE `xadmin_companygroup` DISABLE KEYS */;
INSERT INTO `xadmin_companygroup` VALUES (2,1),(3,1),(4,1),(5,1),(6,1),(7,1),(8,1),(9,1),(10,1);
/*!40000 ALTER TABLE `xadmin_companygroup` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `xadmin_usersettings`
--

DROP TABLE IF EXISTS `xadmin_usersettings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `xadmin_usersettings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `key` varchar(256) NOT NULL,
  `value` longtext NOT NULL,
  PRIMARY KEY (`id`),
  KEY `xadmin_usersettings_6340c63c` (`user_id`),
  CONSTRAINT `user_id_refs_id_b50d6e52` FOREIGN KEY (`user_id`) REFERENCES `company_employee` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `xadmin_usersettings`
--

LOCK TABLES `xadmin_usersettings` WRITE;
/*!40000 ALTER TABLE `xadmin_usersettings` DISABLE KEYS */;
INSERT INTO `xadmin_usersettings` VALUES (1,1,'dashboard:home:pos',''),(2,2,'dashboard:home:pos','');
/*!40000 ALTER TABLE `xadmin_usersettings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `xadmin_userwidget`
--

DROP TABLE IF EXISTS `xadmin_userwidget`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `xadmin_userwidget` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `page_id` varchar(256) NOT NULL,
  `widget_type` varchar(50) NOT NULL,
  `value` longtext NOT NULL,
  PRIMARY KEY (`id`),
  KEY `xadmin_userwidget_6340c63c` (`user_id`),
  CONSTRAINT `user_id_refs_id_9f5f8aa3` FOREIGN KEY (`user_id`) REFERENCES `company_employee` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `xadmin_userwidget`
--

LOCK TABLES `xadmin_userwidget` WRITE;
/*!40000 ALTER TABLE `xadmin_userwidget` DISABLE KEYS */;
/*!40000 ALTER TABLE `xadmin_userwidget` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2015-11-02  6:13:40
