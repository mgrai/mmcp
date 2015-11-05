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
) ENGINE=InnoDB AUTO_INCREMENT=713 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group_permissions`
--

LOCK TABLES `auth_group_permissions` WRITE;
/*!40000 ALTER TABLE `auth_group_permissions` DISABLE KEYS */;
INSERT INTO `auth_group_permissions` VALUES (163,2,52),(164,2,53),(165,2,54),(166,2,55),(167,2,56),(168,2,57),(169,2,58),(170,2,59),(171,2,61),(172,2,62),(173,2,63),(174,2,64),(175,2,65),(176,2,66),(177,2,71),(178,2,72),(179,2,106),(180,2,107),(181,2,108),(182,2,120),(160,2,153),(161,2,154),(162,2,171),(140,3,52),(141,3,53),(142,3,54),(143,3,55),(144,3,56),(145,3,57),(146,3,58),(147,3,59),(148,3,61),(149,3,62),(150,3,63),(151,3,64),(152,3,65),(153,3,66),(154,3,71),(155,3,72),(156,3,106),(157,3,107),(158,3,108),(159,3,120),(138,3,153),(139,3,154),(47,6,52),(48,6,53),(49,6,54),(50,6,55),(51,6,56),(52,6,57),(53,6,58),(54,6,59),(55,6,61),(56,6,62),(57,6,63),(58,6,64),(59,6,65),(60,6,66),(61,6,71),(62,6,72),(63,6,95),(64,6,96),(65,6,106),(66,6,107),(67,6,108),(68,6,120),(45,6,153),(46,6,154),(462,7,52),(463,7,53),(464,7,54),(465,7,55),(466,7,58),(467,7,71),(468,7,72),(469,7,90),(470,7,93),(471,7,121),(472,7,122),(473,7,123),(474,7,124),(475,7,125),(476,7,126),(477,7,127),(430,7,128),(431,7,129),(432,7,133),(433,7,134),(434,7,135),(435,7,136),(436,7,137),(437,7,138),(438,7,139),(439,7,140),(440,7,141),(441,7,142),(442,7,143),(443,7,146),(444,7,147),(445,7,148),(446,7,155),(447,7,156),(448,7,157),(449,7,158),(450,7,159),(451,7,160),(452,7,161),(453,7,162),(454,7,163),(455,7,164),(456,7,165),(457,7,166),(458,7,167),(459,7,168),(460,7,169),(461,7,170),(83,8,67),(84,8,68),(85,8,69),(86,8,70),(87,8,71),(88,8,72),(90,8,89),(96,8,90),(94,8,91),(95,8,92),(89,8,93),(97,8,94),(98,8,95),(82,8,96),(91,8,120),(92,8,153),(93,8,154),(696,9,52),(697,9,53),(698,9,54),(699,9,55),(700,9,58),(701,9,71),(702,9,90),(703,9,93),(704,9,96),(705,9,116),(706,9,121),(707,9,122),(708,9,123),(709,9,124),(710,9,125),(711,9,126),(712,9,127),(664,9,128),(665,9,129),(666,9,133),(667,9,134),(668,9,135),(669,9,136),(670,9,137),(671,9,138),(672,9,139),(673,9,140),(674,9,141),(675,9,142),(676,9,143),(677,9,146),(678,9,147),(679,9,148),(680,9,155),(681,9,156),(682,9,157),(683,9,158),(684,9,159),(685,9,160),(686,9,161),(687,9,162),(688,9,163),(689,9,164),(690,9,165),(691,9,166),(692,9,167),(693,9,168),(694,9,169),(695,9,170),(75,10,56),(76,10,57),(77,10,58),(78,10,59),(79,10,61),(80,10,62),(81,10,63),(69,10,64),(70,10,65),(71,10,66),(72,10,71),(73,10,72),(74,10,171);
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
) ENGINE=InnoDB AUTO_INCREMENT=172 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add permission',1,'add_permission'),(2,'Can change permission',1,'change_permission'),(3,'Can delete permission',1,'delete_permission'),(4,'Can add group',2,'add_group'),(5,'Can change group',2,'change_group'),(6,'Can delete group',2,'delete_group'),(7,'Can view group',2,'view_group'),(8,'Can view permission',1,'view_permission'),(9,'Can add content type',3,'add_contenttype'),(10,'Can change content type',3,'change_contenttype'),(11,'Can delete content type',3,'delete_contenttype'),(12,'Can view content type',3,'view_contenttype'),(13,'Can add session',4,'add_session'),(14,'Can change session',4,'change_session'),(15,'Can delete session',4,'delete_session'),(16,'Can view session',4,'view_session'),(17,'Can add site',5,'add_site'),(18,'Can change site',5,'change_site'),(19,'Can delete site',5,'delete_site'),(20,'Can view site',5,'view_site'),(21,'Can add revision',6,'add_revision'),(22,'Can change revision',6,'change_revision'),(23,'Can delete revision',6,'delete_revision'),(24,'Can add version',7,'add_version'),(25,'Can change version',7,'change_version'),(26,'Can delete version',7,'delete_version'),(27,'Can view revision',6,'view_revision'),(28,'Can view version',7,'view_version'),(29,'Can add 公司',8,'add_company'),(30,'Can change 公司',8,'change_company'),(31,'Can delete 公司',8,'delete_company'),(32,'Can add user',9,'add_employee'),(33,'Can change user',9,'change_employee'),(34,'Can delete user',9,'delete_employee'),(35,'Can view user',9,'view_employee'),(36,'Can view 公司',8,'view_company'),(37,'Can add 类别',10,'add_category'),(38,'Can change 类别',10,'change_category'),(39,'Can delete 类别',10,'delete_category'),(40,'Can add 规格',11,'add_specification'),(41,'Can change 规格',11,'change_specification'),(42,'Can delete 规格',11,'delete_specification'),(43,'Can add 单位',12,'add_unit'),(44,'Can change 单位',12,'change_unit'),(45,'Can delete 单位',12,'delete_unit'),(46,'Can add 材料',13,'add_material'),(47,'Can change 材料',13,'change_material'),(48,'Can delete 材料',13,'delete_material'),(49,'Can add 品牌',14,'add_brand'),(50,'Can change 品牌',14,'change_brand'),(51,'Can delete 品牌',14,'delete_brand'),(52,'Can add 供应商',15,'add_vendor'),(53,'Can change 供应商',15,'change_vendor'),(54,'Can delete 供应商',15,'delete_vendor'),(55,'Can view 供应商',15,'view_vendor'),(56,'Can view 单位',12,'view_unit'),(57,'Can view 品牌',14,'view_brand'),(58,'Can view 材料',13,'view_material'),(59,'Can view 类别',10,'view_category'),(60,'Can view 规格',11,'view_specification'),(61,'Can add 项目',16,'add_project'),(62,'Can change 项目',16,'change_project'),(63,'Can delete 项目',16,'delete_project'),(64,'Can add 项目材料',17,'add_projectmaterial'),(65,'Can change 项目材料',17,'change_projectmaterial'),(66,'Can delete 项目材料',17,'delete_projectmaterial'),(67,'Can add 材料选择',18,'add_selectedlineitem'),(68,'Can change 材料选择',18,'change_selectedlineitem'),(69,'Can delete 材料选择',18,'delete_selectedlineitem'),(70,'Can view 材料选择',18,'view_selectedlineitem'),(71,'Can view 项目',16,'view_project'),(72,'Can view 项目材料',17,'view_projectmaterial'),(73,'Can add Bookmark',19,'add_bookmark'),(74,'Can change Bookmark',19,'change_bookmark'),(75,'Can delete Bookmark',19,'delete_bookmark'),(76,'Can add User Setting',20,'add_usersettings'),(77,'Can change User Setting',20,'change_usersettings'),(78,'Can delete User Setting',20,'delete_usersettings'),(79,'Can add User Widget',21,'add_userwidget'),(80,'Can change User Widget',21,'change_userwidget'),(81,'Can delete User Widget',21,'delete_userwidget'),(85,'Can view Bookmark',19,'view_bookmark'),(86,'Can view User Setting',20,'view_usersettings'),(87,'Can view User Widget',21,'view_userwidget'),(89,'Can add 单据',23,'add_document'),(90,'Can change 单据',23,'change_document'),(91,'Can delete 单据',23,'delete_document'),(92,'Can add 单据名细',24,'add_documentlineitem'),(93,'Can change 单据名细',24,'change_documentlineitem'),(94,'Can delete 单据名细',24,'delete_documentlineitem'),(95,'Can view 单据',23,'view_document'),(96,'Can view 单据名细',24,'view_documentlineitem'),(97,'Can add 流程',25,'add_route'),(98,'Can change 流程',25,'change_route'),(99,'Can delete 流程',25,'delete_route'),(100,'Can add 步骤',26,'add_actor'),(101,'Can change 步骤',26,'change_actor'),(102,'Can delete 步骤',26,'delete_actor'),(103,'Can add 步骤处理人',27,'add_actoruser'),(104,'Can change 步骤处理人',27,'change_actoruser'),(105,'Can delete 步骤处理人',27,'delete_actoruser'),(106,'Can add 项目申请',28,'add_item'),(107,'Can change 项目申请',28,'change_item'),(108,'Can delete 项目申请',28,'delete_item'),(109,'Can add 任务列表',29,'add_tasklist'),(110,'Can change 任务列表',29,'change_tasklist'),(111,'Can delete 任务列表',29,'delete_tasklist'),(112,'Can add 审核日志',30,'add_taskhistory'),(113,'Can change 审核日志',30,'change_taskhistory'),(114,'Can delete 审核日志',30,'delete_taskhistory'),(115,'Can view 任务列表',29,'view_tasklist'),(116,'Can view 审核日志',30,'view_taskhistory'),(117,'Can view 步骤',26,'view_actor'),(118,'Can view 步骤处理人',27,'view_actoruser'),(119,'Can view 流程',25,'view_route'),(120,'Can view 项目申请',28,'view_item'),(121,'Can add 采购单注意事项',31,'add_ordernote'),(122,'Can change 采购单注意事项',31,'change_ordernote'),(123,'Can delete 采购单注意事项',31,'delete_ordernote'),(124,'Can add 采购单',32,'add_order'),(125,'Can change 采购单',32,'change_order'),(126,'Can delete 采购单',32,'delete_order'),(127,'Can add 采购单名细',33,'add_orderline'),(128,'Can change 采购单名细',33,'change_orderline'),(129,'Can delete 采购单名细',33,'delete_orderline'),(130,'Can add 对账单',34,'add_checkaccount'),(131,'Can change 对账单',34,'change_checkaccount'),(132,'Can delete 对账单',34,'delete_checkaccount'),(133,'Can add 到货单名细',35,'add_receivingline'),(134,'Can change 到货单名细',35,'change_receivingline'),(135,'Can delete 到货单名细',35,'delete_receivingline'),(136,'Can add 对账单名细',35,'add_checkaccountdetail'),(137,'Can change 对账单名细',35,'change_checkaccountdetail'),(138,'Can delete 对账单名细',35,'delete_checkaccountdetail'),(139,'Can add 发票',36,'add_invoice'),(140,'Can change 发票',36,'change_invoice'),(141,'Can delete 发票',36,'delete_invoice'),(142,'Can view 到货单名细',35,'view_receivingline'),(143,'Can view 发票',36,'view_invoice'),(144,'Can view 对账单',34,'view_checkaccount'),(145,'Can view 对账单名细',37,'view_checkaccountdetail'),(146,'Can view 采购单',32,'view_order'),(147,'Can view 采购单名细',33,'view_orderline'),(148,'Can view 采购单注意事项',31,'view_ordernote'),(149,'can change group',38,'change_companygroup'),(150,'can add group',38,'add_companygroup'),(151,'can view group',38,'view_companygroup'),(152,'can delete group',38,'delete_companygroup'),(153,'can handle item',28,'handle_item'),(154,'can handled item',28,'handled_item'),(155,'Can add 支付方式',39,'add_paymenttype'),(156,'Can change 支付方式',39,'change_paymenttype'),(157,'Can delete 支付方式',39,'delete_paymenttype'),(158,'Can add 款项属性',40,'add_paymentproperty'),(159,'Can change 款项属性',40,'change_paymentproperty'),(160,'Can delete 款项属性',40,'delete_paymentproperty'),(161,'Can add 付款',41,'add_payment'),(162,'Can change 付款',41,'change_payment'),(163,'Can delete 付款',41,'delete_payment'),(164,'Can add 付款',41,'add_dopayemnt'),(165,'Can change 付款',41,'change_dopayemnt'),(166,'Can delete 付款',41,'delete_dopayemnt'),(167,'Can view 付款',41,'view_payment'),(168,'Can view 付款',42,'view_dopayemnt'),(169,'Can view 支付方式',39,'view_paymenttype'),(170,'Can view 款项属性',40,'view_paymentproperty'),(171,'can search_price',33,'search_price_orderline');
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `company_company`
--

LOCK TABLES `company_company` WRITE;
/*!40000 ALTER TABLE `company_company` DISABLE KEYS */;
INSERT INTO `company_company` VALUES (1,NULL,'合和','合和','合和','13800000','13800000','552100',1,4,1,0),(2,NULL,'南消','南消','南消','138000','138000','521000',1,2,2,0);
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
  `phone` varchar(20) DEFAULT NULL,
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
INSERT INTO `company_employee` VALUES (1,'pbkdf2_sha256$12000$5hSphBuKoqMD$517+Ql4k3FImY54W+9eJlm2W85h7kF6B+S+kEf5WRLA=','2015-11-05 02:27:54',1,'admin','','','admin@mgrai.com',1,1,'2015-11-02 12:32:12',NULL,NULL),(2,'pbkdf2_sha256$12000$ib4eGFViMHGW$lpMxjxt6ZeOIqAyu88J/a7YLmHwZ/x/hDwYRizU9HyE=','2015-11-05 09:30:35',0,'bob','','bob','',1,1,'2015-11-02 13:25:56',1,NULL),(3,'pbkdf2_sha256$12000$FjH3AqEwnwtH$z7GD/Trk1CWz0hVP/5zRFRB2G+Y1fmVbJD6YiqmR1Ag=','2015-11-02 13:26:20',0,'jason','','','',1,1,'2015-11-02 13:26:20',2,NULL),(4,'pbkdf2_sha256$12000$BRoVyLO1iR2c$S5iLd1QucWo2IzG7+aoOTbhPsZcjkBW2VuBjCF5VOUo=','2015-11-05 04:02:36',0,'alex','','alex','',1,1,'2015-11-02 13:39:51',1,NULL),(5,'pbkdf2_sha256$12000$ymdPl4xxaWZh$mXCqHxFbU/5RGXzVQl5dQ3wSLQe4Kyy4qLg6tf8kj3Y=','2015-11-05 06:06:21',0,'ray','','ray','',1,1,'2015-11-02 13:40:23',1,NULL),(6,'pbkdf2_sha256$12000$57mVq6OiGAos$klJogc7+8unpiP6CMGuTV95A3kxO10j3/Df4TllL4wU=','2015-11-05 09:31:04',0,'zeal','','zeal','',1,1,'2015-11-02 13:40:34',1,NULL),(7,'pbkdf2_sha256$12000$SoTaXqoRRQ7n$J3YOTgbSApJN6jSN9ORheJxRAWmNf0DZTShIQDLV3vA=','2015-11-05 07:06:28',0,'jack','','jack','',1,1,'2015-11-02 13:40:45',1,NULL),(8,'pbkdf2_sha256$12000$J5tnLW7moh0j$okx4j/NGHF0kto0xUsFucrNc2tlbSwnQPmjR+52lGA4=','2015-11-05 06:34:28',0,'tom','','tom','',1,1,'2015-11-02 13:40:53',1,NULL),(9,'pbkdf2_sha256$12000$Dg5kH65nmZIL$rSGHyvBOr5VnWdFGqC4Kbjzze2Jq61n5QlENFqzo3wQ=','2015-11-05 06:33:24',0,'jeff','','jeff','',1,1,'2015-11-02 13:41:03',1,NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `company_employee_groups`
--

LOCK TABLES `company_employee_groups` WRITE;
/*!40000 ALTER TABLE `company_employee_groups` DISABLE KEYS */;
INSERT INTO `company_employee_groups` VALUES (16,4,8),(19,5,6),(18,5,10),(15,6,9),(11,7,7),(14,8,2),(10,9,3);
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
) ENGINE=InnoDB AUTO_INCREMENT=770 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `company_employee_user_permissions`
--

LOCK TABLES `company_employee_user_permissions` WRITE;
/*!40000 ALTER TABLE `company_employee_user_permissions` DISABLE KEYS */;
INSERT INTO `company_employee_user_permissions` VALUES (693,2,1),(694,2,4),(695,2,5),(696,2,6),(697,2,7),(698,2,8),(699,2,9),(700,2,10),(701,2,11),(702,2,12),(703,2,13),(704,2,14),(705,2,15),(706,2,16),(707,2,17),(708,2,18),(709,2,19),(710,2,20),(711,2,21),(712,2,22),(713,2,23),(714,2,24),(715,2,25),(716,2,26),(717,2,27),(718,2,28),(720,2,32),(721,2,33),(722,2,34),(723,2,35),(725,2,52),(726,2,53),(727,2,54),(728,2,55),(729,2,56),(730,2,57),(731,2,58),(732,2,59),(764,2,60),(734,2,61),(735,2,62),(736,2,63),(737,2,64),(738,2,65),(739,2,66),(740,2,67),(741,2,68),(742,2,69),(743,2,70),(744,2,71),(745,2,72),(746,2,73),(747,2,74),(748,2,75),(749,2,76),(750,2,77),(751,2,78),(752,2,79),(753,2,80),(754,2,81),(756,2,97),(757,2,98),(758,2,99),(759,2,100),(760,2,101),(761,2,102),(762,2,103),(763,2,104),(767,2,105),(765,2,117),(766,2,118),(768,2,119),(769,2,149),(719,2,150),(733,2,151),(755,2,152),(724,2,171);
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
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (1,'permission','auth','permission'),(2,'group','auth','group'),(3,'content type','contenttypes','contenttype'),(4,'session','sessions','session'),(5,'site','sites','site'),(6,'revision','reversion','revision'),(7,'version','reversion','version'),(8,'公司','company','company'),(9,'user','company','employee'),(10,'类别','material','category'),(11,'规格','material','specification'),(12,'单位','material','unit'),(13,'材料','material','material'),(14,'品牌','material','brand'),(15,'供应商','material','vendor'),(16,'项目','project','project'),(17,'项目材料','project','projectmaterial'),(18,'材料选择','project','selectedlineitem'),(19,'Bookmark','xadmin','bookmark'),(20,'User Setting','xadmin','usersettings'),(21,'User Widget','xadmin','userwidget'),(23,'单据','document','document'),(24,'单据名细','document','documentlineitem'),(25,'流程','workflow','route'),(26,'步骤','workflow','actor'),(27,'步骤处理人','workflow','actoruser'),(28,'项目申请','workflow','item'),(29,'任务列表','workflow','tasklist'),(30,'审核日志','workflow','taskhistory'),(31,'采购单注意事项','order','ordernote'),(32,'采购单','order','order'),(33,'采购单名细','order','orderline'),(34,'对账单','order','checkaccount'),(35,'到货单名细','order','receivingline'),(36,'发票','order','invoice'),(37,'对账单名细','order','checkaccountdetail'),(38,'部门','xadmin','companygroup'),(39,'支付方式','payment','paymenttype'),(40,'款项属性','payment','paymentproperty'),(41,'付款','payment','payment'),(42,'付款','payment','dopayemnt');
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
INSERT INTO `django_session` VALUES ('0ffqy1tg1pwsoknpyfwrw4ucxfy69x99','ZDVkMjM5ZjU4NDQxMjIzMTUyZTIxNTNhMWFhMjE0YTRiMGY0OWVhZjp7IkxJU1RfUVVFUlkiOltbImRvY3VtZW50IiwiZG9jdW1lbnQiXSwiIl0sIl9hdXRoX3VzZXJfaWQiOjQsIl9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIn0=','2015-11-18 05:58:24'),('s763ml5izah9gtc8t9tq4gi2pvfhoclf','NGM1NGRkMmEyMjU0NjE1ZDk3NGNiM2E5Y2U1YzA5OTRiYmE3NmI1ZDp7IkxJU1RfUVVFUlkiOltbIndvcmtmbG93Iiwicm91dGUiXSwiIl0sIl9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9pZCI6Mn0=','2015-11-18 06:28:04'),('t60o2y8kw1ksj910n9ezex7hupqq7n6v','MmQ2MDIwNWY0Y2YwMDJkM2U2MWM2ZDdiMjBjNzgwNGI4MDZiNjlhMDp7IkxJU1RfUVVFUlkiOltbImNvbXBhbnkiLCJlbXBsb3llZSJdLCImX3FfPWomX2NvbHM9aWQuX19zdHJfXyZwPTAmXz0xNDQ2NDcyMzQ3OTQxIl0sIl9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9pZCI6Miwid2l6YXJkX3Byb2plY3Rwcm9qZWN0X2FkbWluX3dpemFyZF9mb3JtX3BsdWdpbiI6eyJzdGVwX2ZpbGVzIjp7fSwic3RlcCI6Ilx1OTg3OVx1NzZlZVx1NzI3OVx1NWY4MSIsImV4dHJhX2RhdGEiOnt9LCJzdGVwX2RhdGEiOnt9fX0=','2015-11-16 13:52:37'),('tg2u1req347p7wiltqzpcxx5aip40wqe','MWM2MzFlZjZmMzljNjc3ZjhmNjM5ZTRmYjIwNzNjODE4MGZmYjcxZDp7IkxJU1RfUVVFUlkiOltbIm9yZGVyIiwib3JkZXIiXSwiIl0sIl9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9pZCI6Nn0=','2015-11-19 09:31:25');
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
-- Table structure for table `document_document`
--

DROP TABLE IF EXISTS `document_document`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `document_document` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `document_id` varchar(50) NOT NULL,
  `document_type` smallint(6) NOT NULL,
  `user_id` int(11) NOT NULL,
  `create_date` date DEFAULT NULL,
  `purch_status` varchar(20) NOT NULL,
  `project_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `document_document_6340c63c` (`user_id`),
  KEY `document_document_37952554` (`project_id`),
  CONSTRAINT `project_id_refs_id_a256ae76` FOREIGN KEY (`project_id`) REFERENCES `project_project` (`id`),
  CONSTRAINT `user_id_refs_id_fc69868f` FOREIGN KEY (`user_id`) REFERENCES `company_employee` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `document_document`
--

LOCK TABLES `document_document` WRITE;
/*!40000 ALTER TABLE `document_document` DISABLE KEYS */;
INSERT INTO `document_document` VALUES (2,'PM20151104111214',0,4,'2015-11-04','未采购',2),(4,'PM20151104152334',0,4,'2015-11-04','采购完成',2),(5,'PM20151104171739',0,4,'2015-11-04','采购完成',2);
/*!40000 ALTER TABLE `document_document` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `document_documentlineitem`
--

DROP TABLE IF EXISTS `document_documentlineitem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `document_documentlineitem` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `document_id` int(11) NOT NULL,
  `projectMaterial_id` int(11) NOT NULL,
  `brand_id` int(11) DEFAULT NULL,
  `expected_quantity` int(11) DEFAULT NULL,
  `posted_quantity` int(11) DEFAULT NULL,
  `audit_quantity` int(11) DEFAULT NULL,
  `expected_date` date DEFAULT NULL,
  `comments` longtext,
  `approval_comments` longtext,
  `file` varchar(100) NOT NULL,
  `material` varchar(250) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `document_documentlineitem_b7398729` (`document_id`),
  KEY `document_documentlineitem_271e2461` (`projectMaterial_id`),
  KEY `document_documentlineitem_5afadb1e` (`brand_id`),
  CONSTRAINT `brand_id_refs_id_27c3280c` FOREIGN KEY (`brand_id`) REFERENCES `material_brand` (`id`),
  CONSTRAINT `document_id_refs_id_73ca7c56` FOREIGN KEY (`document_id`) REFERENCES `document_document` (`id`),
  CONSTRAINT `projectMaterial_id_refs_id_773995b0` FOREIGN KEY (`projectMaterial_id`) REFERENCES `project_projectmaterial` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `document_documentlineitem`
--

LOCK TABLES `document_documentlineitem` WRITE;
/*!40000 ALTER TABLE `document_documentlineitem` DISABLE KEYS */;
INSERT INTO `document_documentlineitem` VALUES (3,2,1,NULL,10,NULL,NULL,'2015-11-04','test',NULL,'',NULL),(4,2,2,NULL,2,NULL,NULL,'2015-11-04',NULL,NULL,'',NULL),(7,4,1,NULL,10,10,NULL,'2015-11-04',NULL,NULL,'',NULL),(8,4,2,NULL,10,30,NULL,'2015-11-04',NULL,NULL,'',NULL),(9,5,1,NULL,10,NULL,NULL,'2015-11-04',NULL,NULL,'',NULL);
/*!40000 ALTER TABLE `document_documentlineitem` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `material_brand`
--

LOCK TABLES `material_brand` WRITE;
/*!40000 ALTER TABLE `material_brand` DISABLE KEYS */;
INSERT INTO `material_brand` VALUES (1,'dd');
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `material_category`
--

LOCK TABLES `material_category` WRITE;
/*!40000 ALTER TABLE `material_category` DISABLE KEYS */;
INSERT INTO `material_category` VALUES (1,'卡箍件'),(2,'电线电缆'),(3,'钢材类');
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
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `material_material`
--

LOCK TABLES `material_material` WRITE;
/*!40000 ALTER TABLE `material_material` DISABLE KEYS */;
INSERT INTO `material_material` VALUES (1,'三通','',1,'DN100*50',1),(2,'三通','',1,'DN100*65',1),(3,'三通','',1,'DN100*80',1),(4,'丝扣法兰','',1,'DN100',1),(5,'丝扣法兰','',1,'DN50',1),(6,'侧大三通','',1,'DN30*25*25',1),(7,'侧大三通','',1,'DN32*25*25',1),(8,'偏心大小头','',1,'DN100*80',2),(9,'偏心大小头','',1,'DN150*100',2),(10,'耐火控制电缆','',NULL,'KVV-10*2.5',2),(11,'耐火控制电缆','',NULL,'KVV-16*2.5',2),(12,'电话线（红）','',2,'NH-BV-1.5',2),(13,'电缆','',NULL,'ZR-YJY-3*35+1*16',2),(14,'耐火电线','',2,'NH-BV-2*2.5',2),(15,'阻燃控制电缆','',2,'ZR-KVV-10*2.5',2),(16,'风机多线','',NULL,'WDZN-KYJYP-8*1.5',2),(17,'风机控制箱','',2,'',1);
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `material_unit`
--

LOCK TABLES `material_unit` WRITE;
/*!40000 ALTER TABLE `material_unit` DISABLE KEYS */;
INSERT INTO `material_unit` VALUES (1,'只'),(2,'M');
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
  CONSTRAINT `category_id_refs_id_d13fce6c` FOREIGN KEY (`category_id`) REFERENCES `material_category` (`id`),
  CONSTRAINT `company_id_refs_id_7357d25d` FOREIGN KEY (`company_id`) REFERENCES `company_company` (`id`),
  CONSTRAINT `parent_id_refs_id_fd4d7a4c` FOREIGN KEY (`parent_id`) REFERENCES `material_vendor` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `material_vendor`
--

LOCK TABLES `material_vendor` WRITE;
/*!40000 ALTER TABLE `material_vendor` DISABLE KEYS */;
INSERT INTO `material_vendor` VALUES (1,NULL,'二亮','二亮',1,1,'','','','','','','','','','','',1,2,1,0);
/*!40000 ALTER TABLE `material_vendor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_checkaccount`
--

DROP TABLE IF EXISTS `order_checkaccount`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `order_checkaccount` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `check_account_id` varchar(50) NOT NULL,
  `create_time` date NOT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `vendor_id` int(11) DEFAULT NULL,
  `company_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `order_checkaccount_bc787c37` (`vendor_id`),
  KEY `order_checkaccount_0316dde1` (`company_id`),
  CONSTRAINT `company_id_refs_id_18b39d72` FOREIGN KEY (`company_id`) REFERENCES `company_company` (`id`),
  CONSTRAINT `vendor_id_refs_id_ba36f467` FOREIGN KEY (`vendor_id`) REFERENCES `material_vendor` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_checkaccount`
--

LOCK TABLES `order_checkaccount` WRITE;
/*!40000 ALTER TABLE `order_checkaccount` DISABLE KEYS */;
/*!40000 ALTER TABLE `order_checkaccount` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_invoice`
--

DROP TABLE IF EXISTS `order_invoice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `order_invoice` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `vendor_id` int(11) NOT NULL,
  `company_id` int(11) NOT NULL,
  `invoice_number` varchar(50) NOT NULL,
  `amount` decimal(15,2) NOT NULL,
  `invoice_type` smallint(6) NOT NULL,
  `user_id` int(11) NOT NULL,
  `date` date NOT NULL,
  `receive_date` date DEFAULT NULL,
  `is_received` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `order_invoice_bc787c37` (`vendor_id`),
  KEY `order_invoice_0316dde1` (`company_id`),
  KEY `order_invoice_6340c63c` (`user_id`),
  CONSTRAINT `company_id_refs_id_0cb78776` FOREIGN KEY (`company_id`) REFERENCES `company_company` (`id`),
  CONSTRAINT `user_id_refs_id_f1d5ee0d` FOREIGN KEY (`user_id`) REFERENCES `company_employee` (`id`),
  CONSTRAINT `vendor_id_refs_id_648e0dbe` FOREIGN KEY (`vendor_id`) REFERENCES `material_vendor` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_invoice`
--

LOCK TABLES `order_invoice` WRITE;
/*!40000 ALTER TABLE `order_invoice` DISABLE KEYS */;
/*!40000 ALTER TABLE `order_invoice` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_invoice_checkaccounts`
--

DROP TABLE IF EXISTS `order_invoice_checkaccounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `order_invoice_checkaccounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `invoice_id` int(11) NOT NULL,
  `checkaccount_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `invoice_id` (`invoice_id`,`checkaccount_id`),
  KEY `order_invoice_checkAccounts_2bf5dd79` (`invoice_id`),
  KEY `order_invoice_checkAccounts_ee919749` (`checkaccount_id`),
  CONSTRAINT `invoice_id_refs_id_aef7cc15` FOREIGN KEY (`invoice_id`) REFERENCES `order_invoice` (`id`),
  CONSTRAINT `checkaccount_id_refs_id_81289f5a` FOREIGN KEY (`checkaccount_id`) REFERENCES `order_checkaccount` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_invoice_checkaccounts`
--

LOCK TABLES `order_invoice_checkaccounts` WRITE;
/*!40000 ALTER TABLE `order_invoice_checkaccounts` DISABLE KEYS */;
/*!40000 ALTER TABLE `order_invoice_checkaccounts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_order`
--

DROP TABLE IF EXISTS `order_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `order_order` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` varchar(50) NOT NULL,
  `document_id` int(11) NOT NULL,
  `company_id` int(11) NOT NULL,
  `project_id` int(11) NOT NULL,
  `vendor_id` int(11) DEFAULT NULL,
  `create_time` date NOT NULL,
  `note_id` int(11) DEFAULT NULL,
  `is_closed` tinyint(1) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `order_order_b7398729` (`document_id`),
  KEY `order_order_0316dde1` (`company_id`),
  KEY `order_order_37952554` (`project_id`),
  KEY `order_order_bc787c37` (`vendor_id`),
  KEY `order_order_f6e610e1` (`note_id`),
  KEY `order_order_6340c63c` (`user_id`),
  CONSTRAINT `document_id_refs_id_ba90fb63` FOREIGN KEY (`document_id`) REFERENCES `document_document` (`id`),
  CONSTRAINT `company_id_refs_id_2e8feb57` FOREIGN KEY (`company_id`) REFERENCES `company_company` (`id`),
  CONSTRAINT `note_id_refs_id_207b77f2` FOREIGN KEY (`note_id`) REFERENCES `order_ordernote` (`id`),
  CONSTRAINT `project_id_refs_id_c78edba4` FOREIGN KEY (`project_id`) REFERENCES `project_project` (`id`),
  CONSTRAINT `user_id_refs_id_07cfe8b1` FOREIGN KEY (`user_id`) REFERENCES `company_employee` (`id`),
  CONSTRAINT `vendor_id_refs_id_caac93e2` FOREIGN KEY (`vendor_id`) REFERENCES `material_vendor` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_order`
--

LOCK TABLES `order_order` WRITE;
/*!40000 ALTER TABLE `order_order` DISABLE KEYS */;
INSERT INTO `order_order` VALUES (2,'PO20151105154816',4,1,2,1,'2015-11-05',NULL,0,6),(3,'PO20151105161515',5,1,2,NULL,'2015-11-05',NULL,0,6);
/*!40000 ALTER TABLE `order_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_orderline`
--

DROP TABLE IF EXISTS `order_orderline`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `order_orderline` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) NOT NULL,
  `documentLineItem_id` int(11) NOT NULL,
  `price` decimal(15,2) DEFAULT NULL,
  `expected_date` date DEFAULT NULL,
  `purchase_quantity` int(11) DEFAULT NULL,
  `total` decimal(15,2) DEFAULT NULL,
  `brand_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `order_orderline_68d25c7a` (`order_id`),
  KEY `order_orderline_f0d8b8d9` (`documentLineItem_id`),
  KEY `order_orderline_5afadb1e` (`brand_id`),
  CONSTRAINT `brand_id_refs_id_f5f103ef` FOREIGN KEY (`brand_id`) REFERENCES `material_brand` (`id`),
  CONSTRAINT `documentLineItem_id_refs_id_95720001` FOREIGN KEY (`documentLineItem_id`) REFERENCES `document_documentlineitem` (`id`),
  CONSTRAINT `order_id_refs_id_b91acd28` FOREIGN KEY (`order_id`) REFERENCES `order_order` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_orderline`
--

LOCK TABLES `order_orderline` WRITE;
/*!40000 ALTER TABLE `order_orderline` DISABLE KEYS */;
INSERT INTO `order_orderline` VALUES (3,2,7,5.00,NULL,10,50.00,NULL),(4,2,8,5.00,NULL,10,50.00,NULL),(5,3,9,NULL,NULL,10,0.00,NULL);
/*!40000 ALTER TABLE `order_orderline` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_ordernote`
--

DROP TABLE IF EXISTS `order_ordernote`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `order_ordernote` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `note` longtext NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_ordernote`
--

LOCK TABLES `order_ordernote` WRITE;
/*!40000 ALTER TABLE `order_ordernote` DISABLE KEYS */;
/*!40000 ALTER TABLE `order_ordernote` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_receivingline`
--

DROP TABLE IF EXISTS `order_receivingline`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `order_receivingline` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `orderLine_id` int(11) NOT NULL,
  `receiving_quantity` decimal(15,2) NOT NULL,
  `original_receiving_quantity` decimal(15,2) DEFAULT NULL,
  `receiving_date` date DEFAULT NULL,
  `total` decimal(15,2) DEFAULT NULL,
  `checkAccount_id` int(11) DEFAULT NULL,
  `comments` longtext,
  PRIMARY KEY (`id`),
  KEY `order_receivingline_52cc8aa7` (`orderLine_id`),
  KEY `order_receivingline_84e0fc55` (`checkAccount_id`),
  CONSTRAINT `checkAccount_id_refs_id_c2cc20ba` FOREIGN KEY (`checkAccount_id`) REFERENCES `order_checkaccount` (`id`),
  CONSTRAINT `orderLine_id_refs_id_e18dfc70` FOREIGN KEY (`orderLine_id`) REFERENCES `order_orderline` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_receivingline`
--

LOCK TABLES `order_receivingline` WRITE;
/*!40000 ALTER TABLE `order_receivingline` DISABLE KEYS */;
INSERT INTO `order_receivingline` VALUES (1,4,10.00,10.00,'2015-11-05',50.00,NULL,NULL),(2,3,10.00,10.00,'2015-11-05',50.00,NULL,NULL);
/*!40000 ALTER TABLE `order_receivingline` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payment_payment`
--

DROP TABLE IF EXISTS `payment_payment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `payment_payment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `payment_id` varchar(50) NOT NULL,
  `company_id` int(11) NOT NULL,
  `vendor_id` int(11) NOT NULL,
  `content` varchar(100) NOT NULL,
  `payment_amount` decimal(15,2) NOT NULL,
  `applied_amount` decimal(15,2) DEFAULT NULL,
  `paymentType_id` int(11) NOT NULL,
  `paymentProperty_id` int(11) NOT NULL,
  `purchase_amount` decimal(15,2) DEFAULT NULL,
  `owed_amount` decimal(15,2) DEFAULT NULL,
  `owed_amount_after_payment` decimal(15,2) DEFAULT NULL,
  `payment_user_id` int(11) NOT NULL,
  `purchase_user_id` int(11) DEFAULT NULL,
  `create_time` date DEFAULT NULL,
  `payment_date` date DEFAULT NULL,
  `comments` longtext,
  `is_applied` tinyint(1) NOT NULL,
  `is_closed` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `payment_payment_0316dde1` (`company_id`),
  KEY `payment_payment_bc787c37` (`vendor_id`),
  KEY `payment_payment_f3d1cff5` (`paymentType_id`),
  KEY `payment_payment_eaac4997` (`paymentProperty_id`),
  KEY `payment_payment_c2c68e9d` (`payment_user_id`),
  KEY `payment_payment_03fed1ad` (`purchase_user_id`),
  CONSTRAINT `company_id_refs_id_7e88fdba` FOREIGN KEY (`company_id`) REFERENCES `company_company` (`id`),
  CONSTRAINT `paymentProperty_id_refs_id_e5149e5a` FOREIGN KEY (`paymentProperty_id`) REFERENCES `payment_paymentproperty` (`id`),
  CONSTRAINT `paymentType_id_refs_id_e5e7951e` FOREIGN KEY (`paymentType_id`) REFERENCES `payment_paymenttype` (`id`),
  CONSTRAINT `payment_user_id_refs_id_88f99c65` FOREIGN KEY (`payment_user_id`) REFERENCES `company_employee` (`id`),
  CONSTRAINT `purchase_user_id_refs_id_88f99c65` FOREIGN KEY (`purchase_user_id`) REFERENCES `company_employee` (`id`),
  CONSTRAINT `vendor_id_refs_id_dd3df704` FOREIGN KEY (`vendor_id`) REFERENCES `material_vendor` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment_payment`
--

LOCK TABLES `payment_payment` WRITE;
/*!40000 ALTER TABLE `payment_payment` DISABLE KEYS */;
/*!40000 ALTER TABLE `payment_payment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payment_paymentproperty`
--

DROP TABLE IF EXISTS `payment_paymentproperty`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `payment_paymentproperty` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment_paymentproperty`
--

LOCK TABLES `payment_paymentproperty` WRITE;
/*!40000 ALTER TABLE `payment_paymentproperty` DISABLE KEYS */;
/*!40000 ALTER TABLE `payment_paymentproperty` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payment_paymenttype`
--

DROP TABLE IF EXISTS `payment_paymenttype`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `payment_paymenttype` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment_paymenttype`
--

LOCK TABLES `payment_paymenttype` WRITE;
/*!40000 ALTER TABLE `payment_paymenttype` DISABLE KEYS */;
/*!40000 ALTER TABLE `payment_paymenttype` ENABLE KEYS */;
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
  CONSTRAINT `company_id_refs_id_7850acf1` FOREIGN KEY (`company_id`) REFERENCES `company_company` (`id`),
  CONSTRAINT `estimate_user_id_refs_id_614fcf95` FOREIGN KEY (`estimate_user_id`) REFERENCES `company_employee` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project_project`
--

LOCK TABLES `project_project` WRITE;
/*!40000 ALTER TABLE `project_project` DISABLE KEYS */;
INSERT INTO `project_project` VALUES (1,'万科一期','万科一期',1,'','','',5,NULL,NULL,'','',NULL,NULL,NULL,'',NULL,''),(2,'万科','万科',1,'','','',5,1000.00,NULL,'','','2015-11-03','2015-11-03','2015-11-03','',1000.00,'');
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
  CONSTRAINT `employee_id_refs_id_296e7dbe` FOREIGN KEY (`employee_id`) REFERENCES `company_employee` (`id`),
  CONSTRAINT `project_id_refs_id_64cedd69` FOREIGN KEY (`project_id`) REFERENCES `project_project` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project_project_users`
--

LOCK TABLES `project_project_users` WRITE;
/*!40000 ALTER TABLE `project_project_users` DISABLE KEYS */;
INSERT INTO `project_project_users` VALUES (1,1,4),(2,2,4);
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
  `max_price` decimal(15,2) DEFAULT NULL,
  `total` decimal(15,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `project_projectmaterial_37952554` (`project_id`),
  KEY `project_projectmaterial_6f33f001` (`category_id`),
  KEY `project_projectmaterial_f6ab4be3` (`material_id`),
  CONSTRAINT `category_id_refs_id_9267cf2d` FOREIGN KEY (`category_id`) REFERENCES `material_category` (`id`),
  CONSTRAINT `material_id_refs_id_3972f73a` FOREIGN KEY (`material_id`) REFERENCES `material_material` (`id`),
  CONSTRAINT `project_id_refs_id_445896f6` FOREIGN KEY (`project_id`) REFERENCES `project_project` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project_projectmaterial`
--

LOCK TABLES `project_projectmaterial` WRITE;
/*!40000 ALTER TABLE `project_projectmaterial` DISABLE KEYS */;
INSERT INTO `project_projectmaterial` VALUES (1,2,NULL,1,100,10.00,11.00,1000.00),(2,2,NULL,2,100,10.00,10.50,1000.00);
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
  CONSTRAINT `projectMaterial_id_refs_id_7cb77362` FOREIGN KEY (`projectMaterial_id`) REFERENCES `project_projectmaterial` (`id`),
  CONSTRAINT `user_id_refs_id_b178f144` FOREIGN KEY (`user_id`) REFERENCES `company_employee` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;
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
-- Table structure for table `workflow_actor`
--

DROP TABLE IF EXISTS `workflow_actor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `workflow_actor` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `route_id` int(11) DEFAULT NULL,
  `actor_name` varchar(20) NOT NULL,
  `sort_order` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `workflow_actor_854631fb` (`route_id`),
  CONSTRAINT `route_id_refs_id_380c93bf` FOREIGN KEY (`route_id`) REFERENCES `workflow_route` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `workflow_actor`
--

LOCK TABLES `workflow_actor` WRITE;
/*!40000 ALTER TABLE `workflow_actor` DISABLE KEYS */;
INSERT INTO `workflow_actor` VALUES (1,1,'预算部门经理审批',1),(2,1,'副总经理审批',2),(3,1,'总经理审批',3),(4,2,'预算部门经理审批',1),(5,2,'副总经理审批',2),(6,2,'总经理审批',3);
/*!40000 ALTER TABLE `workflow_actor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `workflow_actoruser`
--

DROP TABLE IF EXISTS `workflow_actoruser`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `workflow_actoruser` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `actor_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `workflow_actoruser_b6bbc2ee` (`actor_id`),
  KEY `workflow_actoruser_6340c63c` (`user_id`),
  CONSTRAINT `user_id_refs_id_1ae24f1d` FOREIGN KEY (`user_id`) REFERENCES `company_employee` (`id`),
  CONSTRAINT `actor_id_refs_id_f0ec64a6` FOREIGN KEY (`actor_id`) REFERENCES `workflow_actor` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `workflow_actoruser`
--

LOCK TABLES `workflow_actoruser` WRITE;
/*!40000 ALTER TABLE `workflow_actoruser` DISABLE KEYS */;
INSERT INTO `workflow_actoruser` VALUES (1,1,5),(2,2,9),(3,3,8),(4,4,5),(5,5,9),(6,6,8);
/*!40000 ALTER TABLE `workflow_actoruser` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `workflow_item`
--

DROP TABLE IF EXISTS `workflow_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `workflow_item` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `document_id` int(11) NOT NULL,
  `item_name` varchar(50) NOT NULL,
  `route_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `status` smallint(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `workflow_item_b7398729` (`document_id`),
  KEY `workflow_item_854631fb` (`route_id`),
  KEY `workflow_item_6340c63c` (`user_id`),
  CONSTRAINT `route_id_refs_id_3dbaff88` FOREIGN KEY (`route_id`) REFERENCES `workflow_route` (`id`),
  CONSTRAINT `document_id_refs_id_0c431d66` FOREIGN KEY (`document_id`) REFERENCES `document_document` (`id`),
  CONSTRAINT `user_id_refs_id_fda339f2` FOREIGN KEY (`user_id`) REFERENCES `company_employee` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `workflow_item`
--

LOCK TABLES `workflow_item` WRITE;
/*!40000 ALTER TABLE `workflow_item` DISABLE KEYS */;
INSERT INTO `workflow_item` VALUES (1,2,'项目材料申请',1,4,0),(2,4,'项目材料申请',1,4,2),(3,5,'项目材料申请',1,4,2);
/*!40000 ALTER TABLE `workflow_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `workflow_route`
--

DROP TABLE IF EXISTS `workflow_route`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `workflow_route` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `route_name` varchar(20) NOT NULL,
  `group_id` int(11) DEFAULT NULL,
  `company_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `workflow_route_5f412f9a` (`group_id`),
  KEY `workflow_route_0316dde1` (`company_id`),
  CONSTRAINT `company_id_refs_id_3d127632` FOREIGN KEY (`company_id`) REFERENCES `company_company` (`id`),
  CONSTRAINT `group_id_refs_id_fab60d9f` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `workflow_route`
--

LOCK TABLES `workflow_route` WRITE;
/*!40000 ALTER TABLE `workflow_route` DISABLE KEYS */;
INSERT INTO `workflow_route` VALUES (1,'项目材料申请',8,1),(2,'付款申请',7,1);
/*!40000 ALTER TABLE `workflow_route` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `workflow_taskhistory`
--

DROP TABLE IF EXISTS `workflow_taskhistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `workflow_taskhistory` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `item_id` int(11) DEFAULT NULL,
  `actor_id` int(11) DEFAULT NULL,
  `status` smallint(6) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `create_date` datetime NOT NULL,
  `comments` longtext NOT NULL,
  PRIMARY KEY (`id`),
  KEY `workflow_taskhistory_0a47aae8` (`item_id`),
  KEY `workflow_taskhistory_b6bbc2ee` (`actor_id`),
  KEY `workflow_taskhistory_6340c63c` (`user_id`),
  CONSTRAINT `user_id_refs_id_838580d0` FOREIGN KEY (`user_id`) REFERENCES `company_employee` (`id`),
  CONSTRAINT `actor_id_refs_id_0e7a1a95` FOREIGN KEY (`actor_id`) REFERENCES `workflow_actor` (`id`),
  CONSTRAINT `item_id_refs_id_8804e046` FOREIGN KEY (`item_id`) REFERENCES `workflow_item` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `workflow_taskhistory`
--

LOCK TABLES `workflow_taskhistory` WRITE;
/*!40000 ALTER TABLE `workflow_taskhistory` DISABLE KEYS */;
INSERT INTO `workflow_taskhistory` VALUES (1,3,1,1,5,'2015-11-05 06:06:33',''),(2,2,1,1,5,'2015-11-05 06:06:33',''),(3,3,2,1,9,'2015-11-05 06:33:48',''),(4,2,2,1,9,'2015-11-05 06:33:48',''),(5,3,3,1,8,'2015-11-05 06:34:37',''),(6,2,3,1,8,'2015-11-05 06:34:37','');
/*!40000 ALTER TABLE `workflow_taskhistory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `workflow_tasklist`
--

DROP TABLE IF EXISTS `workflow_tasklist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `workflow_tasklist` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `item_id` int(11) DEFAULT NULL,
  `actor_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `workflow_tasklist_0a47aae8` (`item_id`),
  KEY `workflow_tasklist_b6bbc2ee` (`actor_id`),
  CONSTRAINT `actor_id_refs_id_07186254` FOREIGN KEY (`actor_id`) REFERENCES `workflow_actor` (`id`),
  CONSTRAINT `item_id_refs_id_bcada7d7` FOREIGN KEY (`item_id`) REFERENCES `workflow_item` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `workflow_tasklist`
--

LOCK TABLES `workflow_tasklist` WRITE;
/*!40000 ALTER TABLE `workflow_tasklist` DISABLE KEYS */;
INSERT INTO `workflow_tasklist` VALUES (1,1,1),(2,2,3),(3,3,3);
/*!40000 ALTER TABLE `workflow_tasklist` ENABLE KEYS */;
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
  CONSTRAINT `content_type_id_refs_id_af66fd92` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `user_id_refs_id_fc7bfe39` FOREIGN KEY (`user_id`) REFERENCES `company_employee` (`id`)
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
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `xadmin_usersettings`
--

LOCK TABLES `xadmin_usersettings` WRITE;
/*!40000 ALTER TABLE `xadmin_usersettings` DISABLE KEYS */;
INSERT INTO `xadmin_usersettings` VALUES (1,1,'dashboard:home:pos',''),(2,2,'dashboard:home:pos',''),(3,4,'dashboard:home:pos',''),(4,5,'dashboard:home:pos',''),(5,9,'dashboard:home:pos',''),(6,8,'dashboard:home:pos',''),(7,7,'dashboard:home:pos',''),(8,6,'dashboard:home:pos','');
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

-- Dump completed on 2015-11-05 17:55:51
