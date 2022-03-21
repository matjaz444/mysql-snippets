
CREATE DATABASE /*!32312 IF NOT EXISTS*/ `webshopdb` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `webshop`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `orders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `price` decimal(10,0) NOT NULL DEFAULT '0',
  `datetime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_users-user_id` (`user_id`),
  CONSTRAINT `fk_users-user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
INSERT INTO `orders` VALUES (1,1,333,'2022-03-09 17:50:53'),(2,3,111,'2022-01-19 17:51:27'),(3,1,555,'2022-02-19 17:51:49'),(4,1,111,'2022-03-19 18:02:12'),(5,1,10,'2022-02-19 20:10:37'),(6,2,1234,'2021-12-19 20:33:52'),(7,5,444,'2022-01-13 23:30:28'),(8,5,44,'2022-02-08 23:30:28');
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(20) NOT NULL,
  `country` varchar(20) NOT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
INSERT INTO `users` VALUES (1,'user_si1','Slovenia'),(2,'user_usa1','USA'),(3,'user_de1','Germany'),(4,'user_cog','Congo'),(5,'user_si2','Slovenia'),(6,'user_usa2','USA');
