use mmcp;

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

-- 价格查询
insert into auth_permission(id, name, content_type_id, codename) values(2000, 'can search_price', 23, 'search_price_orderline');

--  待我处理， 已处理
insert into auth_permission(id, name, content_type_id, codename) values(2001, 'can handle item', 31, 'handle_item');
insert into auth_permission(id, name, content_type_id, codename) values(2002, 'can handled item', 31, 'handled_item');