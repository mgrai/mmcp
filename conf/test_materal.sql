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