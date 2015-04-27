# ************************************************************
# Database: outrider
# ************************************************************



# Dump of table projects
# ------------------------------------------------------------

CREATE TABLE `projects` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `domain` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table raw_data
# ------------------------------------------------------------

CREATE TABLE `raw_data` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `date_created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `url` varchar(255) DEFAULT NULL,
  `title_raw` varchar(255) DEFAULT NULL,
  `content_raw` text,
  `status` varchar(255) DEFAULT 'unscraped',
  `author` varchar(255) DEFAULT NULL,
  `date_published_raw` varchar(255) DEFAULT NULL,
  `project_id` int(11) DEFAULT NULL,
  `date_published_timestamp` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


# Our seed data
# -------------------------------------------------------------
INSERT INTO `projects` (`title`, `domain`)
VALUES ('test_project','http://outriderapp.com/test/1'),