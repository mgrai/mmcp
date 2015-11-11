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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=192 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group`
--

LOCK TABLES `auth_group` WRITE;
/*!40000 ALTER TABLE `auth_group` DISABLE KEYS */;
INSERT INTO `auth_group` VALUES (1,'财务部门'),(183,'预算部门经理1'),(184,'采购部门经理1'),(185,'财务部门经理1'),(186,'副总经理1'),(187,'总经理1'),(188,'财务部门1'),(189,'工程部门1'),(190,'采购部门1'),(191,'预算部门1');
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
) ENGINE=InnoDB AUTO_INCREMENT=711 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group_permissions`
--

LOCK TABLES `auth_group_permissions` WRITE;
/*!40000 ALTER TABLE `auth_group_permissions` DISABLE KEYS */;
INSERT INTO `auth_group_permissions` VALUES (1,1,49),(2,47,61),(3,47,62),(4,47,63),(7,47,64),(8,47,65),(9,47,66),(5,47,71),(10,47,72),(11,47,106),(6,47,300),(21,56,58),(12,56,61),(13,56,62),(14,56,63),(17,56,64),(18,56,65),(19,56,66),(15,56,71),(20,56,72),(22,56,106),(16,56,300),(32,57,58),(23,57,61),(24,57,62),(25,57,63),(28,57,64),(29,57,65),(30,57,66),(26,57,71),(31,57,72),(33,57,104),(34,57,105),(35,57,106),(79,57,110),(78,57,131),(38,57,146),(27,57,2000),(36,57,2001),(37,57,2002),(48,65,58),(39,65,61),(40,65,62),(41,65,63),(44,65,64),(45,65,65),(46,65,66),(42,65,71),(47,65,72),(49,65,106),(43,65,300),(59,66,58),(50,66,61),(51,66,62),(52,66,63),(55,66,64),(56,66,65),(57,66,66),(53,66,71),(58,66,72),(60,66,104),(61,66,105),(62,66,106),(63,66,119),(66,66,146),(54,66,2000),(64,66,2001),(65,66,2002),(76,74,58),(67,74,61),(68,74,62),(69,74,63),(72,74,64),(73,74,65),(74,74,66),(70,74,71),(75,74,72),(77,74,106),(71,74,300),(89,75,58),(80,75,61),(81,75,62),(82,75,63),(85,75,64),(86,75,65),(87,75,66),(83,75,71),(88,75,72),(90,75,104),(91,75,105),(92,75,106),(93,75,119),(94,75,131),(97,75,146),(84,75,2000),(95,75,2001),(96,75,2002),(107,83,58),(98,83,61),(99,83,62),(100,83,63),(103,83,64),(104,83,65),(105,83,66),(101,83,71),(106,83,72),(108,83,106),(102,83,300),(118,84,58),(109,84,61),(110,84,62),(111,84,63),(114,84,64),(115,84,65),(116,84,66),(112,84,71),(117,84,72),(119,84,104),(120,84,105),(121,84,106),(124,84,110),(122,84,119),(123,84,131),(127,84,146),(113,84,2000),(125,84,2001),(126,84,2002),(137,92,58),(128,92,61),(129,92,62),(130,92,63),(133,92,64),(134,92,65),(135,92,66),(131,92,71),(136,92,72),(138,92,106),(132,92,300),(148,93,58),(139,93,61),(140,93,62),(141,93,63),(144,93,64),(145,93,65),(146,93,66),(142,93,71),(147,93,72),(149,93,104),(150,93,105),(151,93,106),(152,93,119),(155,93,146),(143,93,2000),(153,93,2001),(154,93,2002),(165,101,58),(156,101,61),(157,101,62),(158,101,63),(161,101,64),(162,101,65),(163,101,66),(159,101,71),(164,101,72),(166,101,106),(160,101,300),(177,102,53),(176,102,58),(167,102,61),(168,102,62),(169,102,63),(172,102,64),(173,102,65),(174,102,66),(170,102,71),(175,102,72),(178,102,104),(179,102,105),(180,102,106),(181,102,119),(184,102,146),(171,102,2000),(182,102,2001),(183,102,2002),(194,110,58),(185,110,61),(186,110,62),(187,110,63),(190,110,64),(191,110,65),(192,110,66),(188,110,71),(193,110,72),(195,110,106),(189,110,300),(206,111,53),(205,111,58),(196,111,61),(197,111,62),(198,111,63),(201,111,64),(202,111,65),(203,111,66),(199,111,71),(204,111,72),(210,111,102),(207,111,104),(208,111,105),(209,111,106),(211,111,119),(214,111,146),(200,111,2000),(212,111,2001),(213,111,2002),(218,117,68),(216,117,71),(217,117,72),(219,117,74),(220,117,79),(221,117,102),(215,117,132),(231,119,58),(222,119,61),(223,119,62),(224,119,63),(227,119,64),(228,119,65),(229,119,66),(225,119,71),(230,119,72),(233,119,102),(232,119,106),(226,119,300),(244,120,53),(243,120,58),(234,120,61),(235,120,62),(236,120,63),(239,120,64),(240,120,65),(241,120,66),(237,120,71),(242,120,72),(248,120,102),(245,120,104),(246,120,105),(247,120,106),(249,120,119),(252,120,146),(238,120,2000),(250,120,2001),(251,120,2002),(256,126,68),(254,126,71),(255,126,72),(257,126,74),(259,126,75),(260,126,77),(261,126,78),(258,126,79),(262,126,102),(253,126,132),(272,128,58),(263,128,61),(264,128,62),(265,128,63),(268,128,64),(269,128,65),(270,128,66),(266,128,71),(271,128,72),(274,128,102),(273,128,106),(267,128,300),(285,129,53),(284,129,58),(275,129,61),(276,129,62),(277,129,63),(280,129,64),(281,129,65),(282,129,66),(278,129,71),(283,129,72),(289,129,102),(286,129,104),(287,129,105),(288,129,106),(290,129,119),(293,129,146),(279,129,2000),(291,129,2001),(292,129,2002),(298,135,68),(299,135,69),(296,135,71),(297,135,72),(300,135,74),(302,135,75),(303,135,77),(304,135,78),(301,135,79),(305,135,102),(295,135,128),(294,135,132),(315,137,58),(306,137,61),(307,137,62),(308,137,63),(311,137,64),(312,137,65),(313,137,66),(309,137,71),(314,137,72),(317,137,102),(316,137,106),(310,137,300),(328,138,53),(327,138,58),(318,138,61),(319,138,62),(320,138,63),(323,138,64),(324,138,65),(325,138,66),(321,138,71),(326,138,72),(332,138,102),(329,138,104),(330,138,105),(331,138,106),(333,138,119),(336,138,146),(322,138,2000),(334,138,2001),(335,138,2002),(341,144,68),(342,144,69),(339,144,71),(340,144,72),(343,144,74),(345,144,75),(346,144,77),(347,144,78),(344,144,79),(348,144,102),(338,144,128),(337,144,132),(353,145,52),(354,145,53),(355,145,54),(356,145,55),(351,145,71),(352,145,72),(357,145,77),(358,145,79),(359,145,85),(360,145,86),(361,145,88),(362,145,89),(364,145,94),(365,145,95),(366,145,99),(367,145,100),(368,145,101),(363,145,102),(369,145,103),(350,145,128),(349,145,132),(379,146,58),(370,146,61),(371,146,62),(372,146,63),(375,146,64),(376,146,65),(377,146,66),(373,146,71),(378,146,72),(381,146,102),(380,146,106),(374,146,300),(392,147,53),(391,147,58),(382,147,61),(383,147,62),(384,147,63),(387,147,64),(388,147,65),(389,147,66),(385,147,71),(390,147,72),(396,147,102),(393,147,104),(394,147,105),(395,147,106),(397,147,119),(400,147,146),(386,147,2000),(398,147,2001),(399,147,2002),(405,153,68),(406,153,69),(403,153,71),(404,153,72),(407,153,74),(409,153,75),(410,153,77),(411,153,78),(408,153,79),(412,153,102),(402,153,128),(401,153,132),(417,154,52),(418,154,53),(419,154,54),(420,154,55),(415,154,71),(416,154,72),(422,154,77),(423,154,85),(424,154,86),(425,154,88),(426,154,89),(428,154,94),(429,154,95),(430,154,99),(431,154,100),(432,154,101),(427,154,102),(433,154,103),(421,154,106),(414,154,128),(413,154,132),(443,155,58),(434,155,61),(435,155,62),(436,155,63),(439,155,64),(440,155,65),(441,155,66),(437,155,71),(442,155,72),(445,155,102),(444,155,106),(438,155,300),(456,156,53),(455,156,58),(446,156,61),(447,156,62),(448,156,63),(451,156,64),(452,156,65),(453,156,66),(449,156,71),(454,156,72),(460,156,102),(457,156,104),(458,156,105),(459,156,106),(461,156,119),(464,156,146),(450,156,2000),(462,156,2001),(463,156,2002),(469,162,68),(470,162,69),(467,162,71),(468,162,72),(471,162,74),(473,162,75),(474,162,77),(475,162,78),(472,162,79),(476,162,102),(466,162,128),(465,162,132),(481,163,52),(482,163,53),(483,163,54),(484,163,55),(479,163,71),(480,163,72),(487,163,74),(486,163,77),(488,163,85),(489,163,86),(490,163,88),(491,163,89),(493,163,94),(494,163,95),(495,163,99),(496,163,100),(497,163,101),(492,163,102),(498,163,103),(485,163,106),(478,163,128),(477,163,132),(508,164,58),(499,164,61),(500,164,62),(501,164,63),(504,164,64),(505,164,65),(506,164,66),(502,164,71),(507,164,72),(510,164,102),(509,164,106),(503,164,300),(521,165,53),(520,165,58),(511,165,61),(512,165,62),(513,165,63),(516,165,64),(517,165,65),(518,165,66),(514,165,71),(519,165,72),(529,165,77),(525,165,102),(522,165,104),(523,165,105),(524,165,106),(526,165,119),(530,165,146),(515,165,2000),(527,165,2001),(528,165,2002),(535,171,68),(536,171,69),(533,171,71),(534,171,72),(537,171,74),(539,171,75),(540,171,77),(541,171,78),(538,171,79),(542,171,102),(532,171,128),(531,171,132),(547,172,52),(548,172,53),(549,172,54),(550,172,55),(545,172,71),(546,172,72),(553,172,74),(552,172,77),(554,172,85),(555,172,86),(556,172,88),(557,172,89),(559,172,94),(560,172,95),(561,172,99),(562,172,100),(563,172,101),(558,172,102),(564,172,103),(551,172,106),(544,172,128),(543,172,132),(574,173,58),(565,173,61),(566,173,62),(567,173,63),(570,173,64),(571,173,65),(572,173,66),(568,173,71),(573,173,72),(576,173,102),(575,173,106),(569,173,300),(587,174,53),(586,174,58),(577,174,61),(578,174,62),(579,174,63),(582,174,64),(583,174,65),(584,174,66),(580,174,71),(585,174,72),(595,174,80),(591,174,102),(588,174,104),(589,174,105),(590,174,106),(592,174,119),(596,174,128),(597,174,146),(581,174,2000),(593,174,2001),(594,174,2002),(602,180,68),(603,180,69),(600,180,71),(601,180,72),(604,180,74),(606,180,75),(607,180,77),(608,180,78),(605,180,79),(609,180,102),(599,180,128),(598,180,132),(614,181,52),(615,181,53),(616,181,54),(617,181,55),(612,181,71),(613,181,72),(620,181,74),(619,181,77),(621,181,85),(622,181,86),(623,181,88),(624,181,89),(626,181,94),(627,181,95),(628,181,99),(629,181,100),(630,181,101),(625,181,102),(631,181,103),(618,181,106),(611,181,128),(610,181,132),(641,182,58),(632,182,61),(633,182,62),(634,182,63),(637,182,64),(638,182,65),(639,182,66),(635,182,71),(640,182,72),(643,182,102),(642,182,106),(636,182,300),(654,183,53),(653,183,58),(644,183,61),(645,183,62),(646,183,63),(649,183,64),(650,183,65),(651,183,66),(647,183,71),(652,183,72),(662,183,77),(658,183,102),(655,183,104),(656,183,105),(657,183,106),(659,183,119),(663,183,128),(664,183,146),(648,183,2000),(660,183,2001),(661,183,2002),(669,189,68),(670,189,69),(667,189,71),(668,189,72),(671,189,74),(673,189,75),(674,189,77),(675,189,78),(672,189,79),(676,189,102),(666,189,128),(665,189,132),(681,190,52),(682,190,53),(683,190,54),(684,190,55),(679,190,71),(680,190,72),(687,190,74),(686,190,77),(688,190,85),(689,190,86),(690,190,88),(691,190,89),(693,190,94),(694,190,95),(695,190,99),(696,190,100),(697,190,101),(692,190,102),(698,190,103),(685,190,106),(678,190,128),(677,190,132),(708,191,58),(699,191,61),(700,191,62),(701,191,63),(704,191,64),(705,191,65),(706,191,66),(702,191,71),(707,191,72),(710,191,102),(709,191,106),(703,191,300);
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
) ENGINE=InnoDB AUTO_INCREMENT=2003 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add permission',1,'add_permission'),(2,'Can change permission',1,'change_permission'),(3,'Can delete permission',1,'delete_permission'),(4,'Can add group',2,'add_group'),(5,'Can change group',2,'change_group'),(6,'Can delete group',2,'delete_group'),(7,'Can view group',2,'view_group'),(8,'Can view permission',1,'view_permission'),(9,'Can add content type',3,'add_contenttype'),(10,'Can change content type',3,'change_contenttype'),(11,'Can delete content type',3,'delete_contenttype'),(12,'Can view content type',3,'view_contenttype'),(13,'Can add session',4,'add_session'),(14,'Can change session',4,'change_session'),(15,'Can delete session',4,'delete_session'),(16,'Can view session',4,'view_session'),(17,'Can add site',5,'add_site'),(18,'Can change site',5,'change_site'),(19,'Can delete site',5,'delete_site'),(20,'Can view site',5,'view_site'),(21,'Can add revision',6,'add_revision'),(22,'Can change revision',6,'change_revision'),(23,'Can delete revision',6,'delete_revision'),(24,'Can add version',7,'add_version'),(25,'Can change version',7,'change_version'),(26,'Can delete version',7,'delete_version'),(27,'Can view revision',6,'view_revision'),(28,'Can view version',7,'view_version'),(29,'Can add 公司',8,'add_company'),(30,'Can change 公司',8,'change_company'),(31,'Can delete 公司',8,'delete_company'),(32,'Can add user',9,'add_employee'),(33,'Can change user',9,'change_employee'),(34,'Can delete user',9,'delete_employee'),(35,'Can view user',9,'view_employee'),(36,'Can view 公司',8,'view_company'),(37,'Can add 类别',10,'add_category'),(38,'Can change 类别',10,'change_category'),(39,'Can delete 类别',10,'delete_category'),(40,'Can add 规格',11,'add_specification'),(41,'Can change 规格',11,'change_specification'),(42,'Can delete 规格',11,'delete_specification'),(43,'Can add 单位',12,'add_unit'),(44,'Can change 单位',12,'change_unit'),(45,'Can delete 单位',12,'delete_unit'),(46,'Can add 材料',13,'add_material'),(47,'Can change 材料',13,'change_material'),(48,'Can delete 材料',13,'delete_material'),(49,'Can add 品牌',14,'add_brand'),(50,'Can change 品牌',14,'change_brand'),(51,'Can delete 品牌',14,'delete_brand'),(52,'Can add 供应商',15,'add_vendor'),(53,'Can change 供应商',15,'change_vendor'),(54,'Can delete 供应商',15,'delete_vendor'),(55,'Can view 供应商',15,'view_vendor'),(56,'Can view 单位',12,'view_unit'),(57,'Can view 品牌',14,'view_brand'),(58,'Can view 材料',13,'view_material'),(59,'Can view 类别',10,'view_category'),(60,'Can view 规格',11,'view_specification'),(61,'Can add 项目',16,'add_project'),(62,'Can change 项目',16,'change_project'),(63,'Can delete 项目',16,'delete_project'),(64,'Can add 项目材料',17,'add_projectmaterial'),(65,'Can change 项目材料',17,'change_projectmaterial'),(66,'Can delete 项目材料',17,'delete_projectmaterial'),(67,'Can add 材料选择',18,'add_selectedlineitem'),(68,'Can change 材料选择',18,'change_selectedlineitem'),(69,'Can delete 材料选择',18,'delete_selectedlineitem'),(70,'Can view 材料选择',18,'view_selectedlineitem'),(71,'Can view 项目',16,'view_project'),(72,'Can view 项目材料',17,'view_projectmaterial'),(73,'Can add 单据',19,'add_document'),(74,'Can change 单据',19,'change_document'),(75,'Can delete 单据',19,'delete_document'),(76,'Can add 单据名细',20,'add_documentlineitem'),(77,'Can change 单据名细',20,'change_documentlineitem'),(78,'Can delete 单据名细',20,'delete_documentlineitem'),(79,'Can view 单据',19,'view_document'),(80,'Can view 单据名细',20,'view_documentlineitem'),(81,'Can add 采购单注意事项',21,'add_ordernote'),(82,'Can change 采购单注意事项',21,'change_ordernote'),(83,'Can delete 采购单注意事项',21,'delete_ordernote'),(84,'Can add 采购单',22,'add_order'),(85,'Can change 采购单',22,'change_order'),(86,'Can delete 采购单',22,'delete_order'),(87,'Can add 采购单名细',23,'add_orderline'),(88,'Can change 采购单名细',23,'change_orderline'),(89,'Can delete 采购单名细',23,'delete_orderline'),(90,'Can add 对账单',24,'add_checkaccount'),(91,'Can change 对账单',24,'change_checkaccount'),(92,'Can delete 对账单',24,'delete_checkaccount'),(93,'Can add 到货单名细',25,'add_receivingline'),(94,'Can change 到货单名细',25,'change_receivingline'),(95,'Can delete 到货单名细',25,'delete_receivingline'),(96,'Can add 对账单名细',25,'add_checkaccountdetail'),(97,'Can change 对账单名细',25,'change_checkaccountdetail'),(98,'Can delete 对账单名细',25,'delete_checkaccountdetail'),(99,'Can add 发票',26,'add_invoice'),(100,'Can change 发票',26,'change_invoice'),(101,'Can delete 发票',26,'delete_invoice'),(102,'Can view 到货单名细',25,'view_receivingline'),(103,'Can view 发票',26,'view_invoice'),(104,'Can view 对账单',24,'view_checkaccount'),(105,'Can view 对账单名细',27,'view_checkaccountdetail'),(106,'Can view 采购单',22,'view_order'),(107,'Can view 采购单名细',23,'view_orderline'),(108,'Can view 采购单注意事项',21,'view_ordernote'),(109,'Can add 流程',28,'add_route'),(110,'Can change 流程',28,'change_route'),(111,'Can delete 流程',28,'delete_route'),(112,'Can add 步骤',29,'add_actor'),(113,'Can change 步骤',29,'change_actor'),(114,'Can delete 步骤',29,'delete_actor'),(115,'Can add 步骤处理人',30,'add_actoruser'),(116,'Can change 步骤处理人',30,'change_actoruser'),(117,'Can delete 步骤处理人',30,'delete_actoruser'),(118,'Can add 项目申请',31,'add_item'),(119,'Can change 项目申请',31,'change_item'),(120,'Can delete 项目申请',31,'delete_item'),(121,'Can add 任务列表',32,'add_tasklist'),(122,'Can change 任务列表',32,'change_tasklist'),(123,'Can delete 任务列表',32,'delete_tasklist'),(124,'Can add 审核日志',33,'add_taskhistory'),(125,'Can change 审核日志',33,'change_taskhistory'),(126,'Can delete 审核日志',33,'delete_taskhistory'),(127,'Can view 任务列表',32,'view_tasklist'),(128,'Can view 审核日志',33,'view_taskhistory'),(129,'Can view 步骤',29,'view_actor'),(130,'Can view 步骤处理人',30,'view_actoruser'),(131,'Can view 流程',28,'view_route'),(132,'Can view 项目申请',31,'view_item'),(133,'Can add 支付方式',34,'add_paymenttype'),(134,'Can change 支付方式',34,'change_paymenttype'),(135,'Can delete 支付方式',34,'delete_paymenttype'),(136,'Can add 款项属性',35,'add_paymentproperty'),(137,'Can change 款项属性',35,'change_paymentproperty'),(138,'Can delete 款项属性',35,'delete_paymentproperty'),(139,'Can add 付款',36,'add_payment'),(140,'Can change 付款',36,'change_payment'),(141,'Can delete 付款',36,'delete_payment'),(142,'Can add 付款',36,'add_dopayemnt'),(143,'Can change 付款',36,'change_dopayemnt'),(144,'Can delete 付款',36,'delete_dopayemnt'),(145,'Can view 付款',36,'view_payment'),(146,'Can view 付款',37,'view_dopayemnt'),(147,'Can view 支付方式',34,'view_paymenttype'),(148,'Can view 款项属性',35,'view_paymentproperty'),(149,'Can add 项目设置',38,'add_projectsetting'),(150,'Can change 项目设置',38,'change_projectsetting'),(151,'Can delete 项目设置',38,'delete_projectsetting'),(152,'Can add 供应商设置',39,'add_vendorsetting'),(153,'Can change 供应商设置',39,'change_vendorsetting'),(154,'Can delete 供应商设置',39,'delete_vendorsetting'),(155,'Can view 供应商设置',39,'view_vendorsetting'),(156,'Can view 项目设置',38,'view_projectsetting'),(157,'Can add Bookmark',40,'add_bookmark'),(158,'Can change Bookmark',40,'change_bookmark'),(159,'Can delete Bookmark',40,'delete_bookmark'),(160,'Can add User Setting',41,'add_usersettings'),(161,'Can change User Setting',41,'change_usersettings'),(162,'Can delete User Setting',41,'delete_usersettings'),(163,'Can add User Widget',42,'add_userwidget'),(164,'Can change User Widget',42,'change_userwidget'),(165,'Can delete User Widget',42,'delete_userwidget'),(166,'Can add 部门',43,'add_companygroup'),(167,'Can change 部门',43,'change_companygroup'),(168,'Can delete 部门',43,'delete_companygroup'),(2000,'can search_price',23,'search_price_orderline'),(2001,'can handle item',31,'handle_item'),(2002,'can handled item',31,'handled_item');
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
INSERT INTO `company_company` VALUES (1,NULL,'合和','合和','合和','13773524511','13773524511','225012',1,2,1,0),(2,NULL,'南消','南消','南消','13773524511','13773524511','225012',1,2,2,0);
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
INSERT INTO `company_employee` VALUES (1,'pbkdf2_sha256$12000$kwpl4l1AAl2n$RX91VpPy/9sbBRQSlHA3Ua9qr0mvamfsPmxPnhFlvVo=','2015-11-11 09:10:56',1,'admin','','','admin@mgrai.com',1,1,'2015-11-10 08:53:18',NULL,NULL),(2,'pbkdf2_sha256$12000$h9wHEtQj5Rft$8bv5pXh/o+sK+r+As/0jAfQEd8VJX5z4rDaLPV25zeU=','2015-11-11 09:34:43',0,'bob','Xiao','Dewen','',1,1,'2015-11-10 08:58:20',1,'13773524511'),(3,'pbkdf2_sha256$12000$wmMHni0JHUm7$N8cnD/pNs6OM9JddOLYgQOfWXuviJfT3OPE8SQe5X7g=','2015-11-11 07:05:59',0,'ray','Xiao','ray','',1,1,'2015-11-11 02:55:27',1,'13773524511'),(4,'pbkdf2_sha256$12000$SaEDhfNhGtOi$cORaAITeBoQ6eBWvCU3631nolU27yn7W0CdJc9A+3dc=','2015-11-11 09:18:15',0,'zeal','Xiao','zeal','',1,1,'2015-11-11 02:55:44',1,'13773524511'),(5,'pbkdf2_sha256$12000$xSDQZ3GbPgIb$Zz7SGrmPSUr5wn2IWSlFu/lk8WxYFV5oVs4eqSJ7NGM=','2015-11-11 09:26:38',0,'alex','','alex','',1,1,'2015-11-11 02:55:51',1,'13773524511'),(6,'pbkdf2_sha256$12000$FioATZ0gwXDm$u9/Khc8t8jiKZmtpS40CSXb3qRe9ekLotXsUkCbJkEo=','2015-11-11 02:56:09',0,'jack','Xiao','jack','',1,1,'2015-11-11 02:56:09',1,'13773524511'),(7,'pbkdf2_sha256$12000$oWnjpeyTfEyR$i5CxQPpPhB/cdR37WrSdrMCqKbxoDRGBuMlr1rECHoA=','2015-11-11 02:56:21',0,'tom','Xiao','tom','',1,1,'2015-11-11 02:56:21',1,'13773524511'),(8,'pbkdf2_sha256$12000$CdLHrRKIPdaD$dRuKLC0Z2bnYVHcLM9yInKkM+CqVyA5YcKtnVZEoQyg=','2015-11-11 02:56:32',0,'jeff','Xiao','jeff','',1,1,'2015-11-11 02:56:32',1,'13773524511'),(9,'pbkdf2_sha256$12000$84V1RESYMksy$uS9qxrPpMYEFumfvhk7tzyjFYkeKUHgZFl46LtcHIjI=','2015-11-11 09:35:24',0,'jason','Xiao','jason','',1,1,'2015-11-11 03:00:30',1,'13773524511');
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
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `company_employee_groups`
--

LOCK TABLES `company_employee_groups` WRITE;
/*!40000 ALTER TABLE `company_employee_groups` DISABLE KEYS */;
INSERT INTO `company_employee_groups` VALUES (20,3,110),(26,4,163),(30,5,180),(2,6,44),(5,7,43),(3,8,42),(31,9,183);
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
) ENGINE=InnoDB AUTO_INCREMENT=729 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `company_employee_user_permissions`
--

LOCK TABLES `company_employee_user_permissions` WRITE;
/*!40000 ALTER TABLE `company_employee_user_permissions` DISABLE KEYS */;
INSERT INTO `company_employee_user_permissions` VALUES (704,2,8),(705,2,32),(706,2,33),(707,2,34),(708,2,35),(721,2,61),(722,2,62),(723,2,63),(725,2,64),(726,2,65),(727,2,66),(724,2,71),(728,2,72),(709,2,109),(710,2,110),(711,2,111),(713,2,112),(714,2,113),(715,2,114),(717,2,115),(718,2,116),(719,2,117),(716,2,129),(720,2,130),(712,2,131),(701,2,166),(702,2,167),(703,2,168);
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
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (1,'permission','auth','permission'),(2,'group','auth','group'),(3,'content type','contenttypes','contenttype'),(4,'session','sessions','session'),(5,'site','sites','site'),(6,'revision','reversion','revision'),(7,'version','reversion','version'),(8,'公司','company','company'),(9,'user','company','employee'),(10,'类别','material','category'),(11,'规格','material','specification'),(12,'单位','material','unit'),(13,'材料','material','material'),(14,'品牌','material','brand'),(15,'供应商','material','vendor'),(16,'项目','project','project'),(17,'项目材料','project','projectmaterial'),(18,'材料选择','project','selectedlineitem'),(19,'单据','document','document'),(20,'单据名细','document','documentlineitem'),(21,'采购单注意事项','order','ordernote'),(22,'采购单','order','order'),(23,'采购单名细','order','orderline'),(24,'对账单','order','checkaccount'),(25,'到货单名细','order','receivingline'),(26,'发票','order','invoice'),(27,'对账单名细','order','checkaccountdetail'),(28,'流程','workflow','route'),(29,'步骤','workflow','actor'),(30,'步骤处理人','workflow','actoruser'),(31,'项目申请','workflow','item'),(32,'任务列表','workflow','tasklist'),(33,'审核日志','workflow','taskhistory'),(34,'支付方式','payment','paymenttype'),(35,'款项属性','payment','paymentproperty'),(36,'付款','payment','payment'),(37,'付款','payment','dopayemnt'),(38,'项目设置','setting','projectsetting'),(39,'供应商设置','setting','vendorsetting'),(40,'Bookmark','xadmin','bookmark'),(41,'User Setting','xadmin','usersettings'),(42,'User Widget','xadmin','userwidget'),(43,'部门','xadmin','companygroup');
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
INSERT INTO `django_session` VALUES ('hhtrpc3stiuo69d01aaywxpp5web9lga','NzI2ODk1NjcyNWFmYWExYTNiNjNiMzY3MmFkM2Y5Y2Q1ZmM2YTVjMjp7IkxJU1RfUVVFUlkiOltbInBheW1lbnQiLCJkb3BheWVtbnQiXSwiIl0sIl9hdXRoX3VzZXJfaWQiOjksIl9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIn0=','2015-11-25 09:38:02');
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
INSERT INTO `document_document` VALUES (2,'PM000120151111152000',0,5,'2015-11-11','未采购',2),(3,'PM000120151111152259',0,5,'2015-11-11','未采购',2),(4,'PM000120151111152907',0,5,'2015-11-11','未采购',2),(5,'PM000120151111172708',0,5,'2015-11-11','未采购',2);
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
  CONSTRAINT `projectMaterial_id_refs_id_773995b0` FOREIGN KEY (`projectMaterial_id`) REFERENCES `project_projectmaterial` (`id`),
  CONSTRAINT `brand_id_refs_id_27c3280c` FOREIGN KEY (`brand_id`) REFERENCES `material_brand` (`id`),
  CONSTRAINT `document_id_refs_id_73ca7c56` FOREIGN KEY (`document_id`) REFERENCES `document_document` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `document_documentlineitem`
--

LOCK TABLES `document_documentlineitem` WRITE;
/*!40000 ALTER TABLE `document_documentlineitem` DISABLE KEYS */;
INSERT INTO `document_documentlineitem` VALUES (3,2,1,NULL,10,NULL,NULL,'2015-11-11',NULL,NULL,'',NULL),(4,2,2,NULL,10,NULL,NULL,'2015-11-11',NULL,NULL,'',NULL),(5,2,3,NULL,10,NULL,NULL,'2015-11-11',NULL,NULL,'',NULL),(6,3,5,NULL,10,NULL,NULL,'2015-11-11',NULL,NULL,'',NULL),(7,3,6,NULL,2,NULL,NULL,'2015-11-11',NULL,NULL,'',NULL),(8,4,1,NULL,10,NULL,NULL,'2015-11-11',NULL,NULL,'',NULL),(9,4,3,NULL,2,NULL,NULL,'2015-11-11',NULL,NULL,'',NULL),(10,5,1,NULL,2,NULL,NULL,'2015-11-11',NULL,NULL,'',NULL),(11,5,3,NULL,2,NULL,NULL,'2015-11-11',NULL,NULL,'',NULL);
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
  CONSTRAINT `company_id_refs_id_7357d25d` FOREIGN KEY (`company_id`) REFERENCES `company_company` (`id`),
  CONSTRAINT `category_id_refs_id_d13fce6c` FOREIGN KEY (`category_id`) REFERENCES `material_category` (`id`),
  CONSTRAINT `parent_id_refs_id_fd4d7a4c` FOREIGN KEY (`parent_id`) REFERENCES `material_vendor` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `material_vendor`
--

LOCK TABLES `material_vendor` WRITE;
/*!40000 ALTER TABLE `material_vendor` DISABLE KEYS */;
INSERT INTO `material_vendor` VALUES (1,NULL,'二亮','二亮',1,1,'二亮','','','','','','','','','','',1,2,1,0);
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_invoice`
--

LOCK TABLES `order_invoice` WRITE;
/*!40000 ALTER TABLE `order_invoice` DISABLE KEYS */;
INSERT INTO `order_invoice` VALUES (1,1,1,'111',1000010.00,1,4,'2015-11-11',NULL,0);
/*!40000 ALTER TABLE `order_invoice` ENABLE KEYS */;
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
  CONSTRAINT `company_id_refs_id_2e8feb57` FOREIGN KEY (`company_id`) REFERENCES `company_company` (`id`),
  CONSTRAINT `document_id_refs_id_ba90fb63` FOREIGN KEY (`document_id`) REFERENCES `document_document` (`id`),
  CONSTRAINT `note_id_refs_id_207b77f2` FOREIGN KEY (`note_id`) REFERENCES `order_ordernote` (`id`),
  CONSTRAINT `project_id_refs_id_c78edba4` FOREIGN KEY (`project_id`) REFERENCES `project_project` (`id`),
  CONSTRAINT `user_id_refs_id_07cfe8b1` FOREIGN KEY (`user_id`) REFERENCES `company_employee` (`id`),
  CONSTRAINT `vendor_id_refs_id_caac93e2` FOREIGN KEY (`vendor_id`) REFERENCES `material_vendor` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_order`
--

LOCK TABLES `order_order` WRITE;
/*!40000 ALTER TABLE `order_order` DISABLE KEYS */;
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
  CONSTRAINT `documentLineItem_id_refs_id_95720001` FOREIGN KEY (`documentLineItem_id`) REFERENCES `document_documentlineitem` (`id`),
  CONSTRAINT `brand_id_refs_id_f5f103ef` FOREIGN KEY (`brand_id`) REFERENCES `material_brand` (`id`),
  CONSTRAINT `order_id_refs_id_b91acd28` FOREIGN KEY (`order_id`) REFERENCES `order_order` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_orderline`
--

LOCK TABLES `order_orderline` WRITE;
/*!40000 ALTER TABLE `order_orderline` DISABLE KEYS */;
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
  `company_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `order_ordernote_0316dde1` (`company_id`),
  CONSTRAINT `company_id_refs_id_d9628d91` FOREIGN KEY (`company_id`) REFERENCES `company_company` (`id`)
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_receivingline`
--

LOCK TABLES `order_receivingline` WRITE;
/*!40000 ALTER TABLE `order_receivingline` DISABLE KEYS */;
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
  `company_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `payment_paymentproperty_0316dde1` (`company_id`),
  CONSTRAINT `company_id_refs_id_7cca2561` FOREIGN KEY (`company_id`) REFERENCES `company_company` (`id`)
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
  `company_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `payment_paymenttype_0316dde1` (`company_id`),
  CONSTRAINT `company_id_refs_id_5ae72164` FOREIGN KEY (`company_id`) REFERENCES `company_company` (`id`)
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
  `estimate_user_id` int(11) DEFAULT NULL,
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
INSERT INTO `project_project` VALUES (1,'万科','万科',1,'','','',3,10000000.00,NULL,'','','2015-11-11','2015-11-11','2015-11-11','',NULL,''),(2,'万科一期','',1,'','','',3,NULL,NULL,'','',NULL,NULL,NULL,'',NULL,'');
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project_project_users`
--

LOCK TABLES `project_project_users` WRITE;
/*!40000 ALTER TABLE `project_project_users` DISABLE KEYS */;
INSERT INTO `project_project_users` VALUES (3,1,5),(2,2,5);
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
  CONSTRAINT `project_id_refs_id_445896f6` FOREIGN KEY (`project_id`) REFERENCES `project_project` (`id`),
  CONSTRAINT `category_id_refs_id_9267cf2d` FOREIGN KEY (`category_id`) REFERENCES `material_category` (`id`),
  CONSTRAINT `material_id_refs_id_3972f73a` FOREIGN KEY (`material_id`) REFERENCES `material_material` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project_projectmaterial`
--

LOCK TABLES `project_projectmaterial` WRITE;
/*!40000 ALTER TABLE `project_projectmaterial` DISABLE KEYS */;
INSERT INTO `project_projectmaterial` VALUES (1,2,NULL,13,100,NULL,NULL,0.00),(2,2,NULL,10,100,NULL,NULL,0.00),(3,2,NULL,11,100,NULL,NULL,0.00),(4,2,NULL,16,100,NULL,NULL,0.00),(5,2,1,1,100,NULL,NULL,0.00),(6,2,1,2,100,NULL,NULL,0.00),(7,2,1,3,100,NULL,NULL,0.00),(8,2,1,4,100,NULL,NULL,0.00),(9,2,1,5,100,NULL,NULL,0.00),(10,2,1,6,100,NULL,NULL,0.00),(11,2,1,7,100,100.00,NULL,10000.00),(12,2,1,8,100,100.00,NULL,10000.00),(13,2,1,9,100,100.00,NULL,10000.00),(14,2,2,12,100,100.00,NULL,10000.00),(15,2,2,14,100,100.00,NULL,10000.00),(16,2,2,15,100,100.00,NULL,10000.00),(17,2,2,17,100,100.00,NULL,10000.00);
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
-- Table structure for table `setting_projectsetting`
--

DROP TABLE IF EXISTS `setting_projectsetting`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `setting_projectsetting` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL,
  `online_before_amount` decimal(15,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `setting_projectsetting_37952554` (`project_id`),
  CONSTRAINT `project_id_refs_id_0a11cdbf` FOREIGN KEY (`project_id`) REFERENCES `project_project` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `setting_projectsetting`
--

LOCK TABLES `setting_projectsetting` WRITE;
/*!40000 ALTER TABLE `setting_projectsetting` DISABLE KEYS */;
/*!40000 ALTER TABLE `setting_projectsetting` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `setting_vendorsetting`
--

DROP TABLE IF EXISTS `setting_vendorsetting`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `setting_vendorsetting` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `vendor_id` int(11) NOT NULL,
  `company_id` int(11) NOT NULL,
  `online_before_owed_amount` decimal(15,2) DEFAULT NULL,
  `online_before_owed_invoice` decimal(15,2) DEFAULT NULL,
  `online_before_received_amount` decimal(15,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `setting_vendorsetting_bc787c37` (`vendor_id`),
  KEY `setting_vendorsetting_0316dde1` (`company_id`),
  CONSTRAINT `company_id_refs_id_233d3bca` FOREIGN KEY (`company_id`) REFERENCES `company_company` (`id`),
  CONSTRAINT `vendor_id_refs_id_12db2471` FOREIGN KEY (`vendor_id`) REFERENCES `material_vendor` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `setting_vendorsetting`
--

LOCK TABLES `setting_vendorsetting` WRITE;
/*!40000 ALTER TABLE `setting_vendorsetting` DISABLE KEYS */;
/*!40000 ALTER TABLE `setting_vendorsetting` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `workflow_actor`
--

LOCK TABLES `workflow_actor` WRITE;
/*!40000 ALTER TABLE `workflow_actor` DISABLE KEYS */;
INSERT INTO `workflow_actor` VALUES (1,1,'预算部门经理审批',1),(2,1,'副总经理审批',2),(3,1,'总经理审批',3);
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
  CONSTRAINT `actor_id_refs_id_f0ec64a6` FOREIGN KEY (`actor_id`) REFERENCES `workflow_actor` (`id`),
  CONSTRAINT `user_id_refs_id_1ae24f1d` FOREIGN KEY (`user_id`) REFERENCES `company_employee` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `workflow_actoruser`
--

LOCK TABLES `workflow_actoruser` WRITE;
/*!40000 ALTER TABLE `workflow_actoruser` DISABLE KEYS */;
INSERT INTO `workflow_actoruser` VALUES (1,1,9),(2,2,8),(3,3,7);
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
  CONSTRAINT `document_id_refs_id_0c431d66` FOREIGN KEY (`document_id`) REFERENCES `document_document` (`id`),
  CONSTRAINT `route_id_refs_id_3dbaff88` FOREIGN KEY (`route_id`) REFERENCES `workflow_route` (`id`),
  CONSTRAINT `user_id_refs_id_fda339f2` FOREIGN KEY (`user_id`) REFERENCES `company_employee` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `workflow_item`
--

LOCK TABLES `workflow_item` WRITE;
/*!40000 ALTER TABLE `workflow_item` DISABLE KEYS */;
INSERT INTO `workflow_item` VALUES (1,2,'项目材料申请',1,5,NULL),(2,3,'项目材料申请',1,5,NULL),(3,4,'项目材料申请',1,5,1),(4,5,'项目材料申请',1,5,0);
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
  CONSTRAINT `group_id_refs_id_fab60d9f` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `company_id_refs_id_3d127632` FOREIGN KEY (`company_id`) REFERENCES `company_company` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `workflow_route`
--

LOCK TABLES `workflow_route` WRITE;
/*!40000 ALTER TABLE `workflow_route` DISABLE KEYS */;
INSERT INTO `workflow_route` VALUES (1,'项目材料申请',100,1),(2,'付款申请',100,1);
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
  CONSTRAINT `actor_id_refs_id_0e7a1a95` FOREIGN KEY (`actor_id`) REFERENCES `workflow_actor` (`id`),
  CONSTRAINT `item_id_refs_id_8804e046` FOREIGN KEY (`item_id`) REFERENCES `workflow_item` (`id`),
  CONSTRAINT `user_id_refs_id_838580d0` FOREIGN KEY (`user_id`) REFERENCES `company_employee` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `workflow_taskhistory`
--

LOCK TABLES `workflow_taskhistory` WRITE;
/*!40000 ALTER TABLE `workflow_taskhistory` DISABLE KEYS */;
INSERT INTO `workflow_taskhistory` VALUES (1,3,1,1,9,'2015-11-11 09:22:36','approve');
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `workflow_tasklist`
--

LOCK TABLES `workflow_tasklist` WRITE;
/*!40000 ALTER TABLE `workflow_tasklist` DISABLE KEYS */;
INSERT INTO `workflow_tasklist` VALUES (1,3,2),(2,4,1);
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
  CONSTRAINT `group_ptr_id_refs_id_f496f25a` FOREIGN KEY (`group_ptr_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `company_id_refs_id_88125bed` FOREIGN KEY (`company_id`) REFERENCES `company_company` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `xadmin_companygroup`
--

LOCK TABLES `xadmin_companygroup` WRITE;
/*!40000 ALTER TABLE `xadmin_companygroup` DISABLE KEYS */;
INSERT INTO `xadmin_companygroup` VALUES (1,1),(12,1),(13,1),(14,1),(15,1),(16,1),(17,1),(18,1),(19,1),(20,1),(21,1),(22,1),(23,1),(24,1),(25,1),(26,1),(27,1),(28,1),(29,1),(30,1),(31,1),(32,1),(33,1),(34,1),(35,1),(36,1),(37,1),(38,1),(39,1),(40,1),(41,1),(42,1),(43,1),(44,1),(45,1),(46,1),(47,1),(48,1),(49,1),(50,1),(51,1),(52,1),(53,1),(54,1),(55,1),(56,1),(57,1),(58,1),(59,1),(60,1),(61,1),(62,1),(63,1),(64,1),(65,1),(66,1),(67,1),(68,1),(69,1),(70,1),(71,1),(72,1),(73,1),(74,1),(75,1),(76,1),(77,1),(78,1),(79,1),(80,1),(81,1),(82,1),(83,1),(84,1),(85,1),(86,1),(87,1),(88,1),(89,1),(90,1),(91,1),(92,1),(93,1),(94,1),(95,1),(96,1),(97,1),(98,1),(99,1),(100,1),(101,1),(102,1),(103,1),(104,1),(105,1),(106,1),(107,1),(108,1),(109,1),(110,1),(111,1),(112,1),(113,1),(114,1),(115,1),(116,1),(117,1),(118,1),(119,1),(120,1),(121,1),(122,1),(123,1),(124,1),(125,1),(126,1),(127,1),(128,1),(129,1),(130,1),(131,1),(132,1),(133,1),(134,1),(135,1),(136,1),(137,1),(138,1),(139,1),(140,1),(141,1),(142,1),(143,1),(144,1),(145,1),(146,1),(147,1),(148,1),(149,1),(150,1),(151,1),(152,1),(153,1),(154,1),(155,1),(156,1),(157,1),(158,1),(159,1),(160,1),(161,1),(162,1),(163,1),(164,1),(165,1),(166,1),(167,1),(168,1),(169,1),(170,1),(171,1),(172,1),(173,1),(174,1),(175,1),(176,1),(177,1),(178,1),(179,1),(180,1),(181,1),(182,1),(183,1),(184,1),(185,1),(186,1),(187,1),(188,1),(189,1),(190,1),(191,1);
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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `xadmin_usersettings`
--

LOCK TABLES `xadmin_usersettings` WRITE;
/*!40000 ALTER TABLE `xadmin_usersettings` DISABLE KEYS */;
INSERT INTO `xadmin_usersettings` VALUES (1,1,'dashboard:home:pos',''),(2,2,'dashboard:home:pos',''),(3,3,'dashboard:home:pos',''),(4,9,'dashboard:home:pos',''),(5,5,'dashboard:home:pos',''),(6,4,'dashboard:home:pos','');
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

-- Dump completed on 2015-11-11 17:40:38
