/*
COPYRIGHT INFORMATION:

Copyright 2007 Joe Rinehart
Copyright 2009 Dennis Clark

LICENSE INFORMATION:
 
Licensed under the Apache License, Version 2.0 (the "License"); you may not 
use this file except in compliance with the License. 

You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0 
	
Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR 
CONDITIONS OF ANY KIND, either express or implied. See the License for the 
specific language governing permissions and limitations under the License.

MODIFIED FILE NOTICE:

Modifier(s): Dennis Clark

This file is a Derivative Work made under and subject to the terms of the above License.

The original source was downloaded from the following location:

	http://www.model-glue.com/downloads/modelglue_2.0.304.zip

This file was derived from /modelgluesamples/Widget/install/mysql.sql.

MODIFIED VERSION INFORMATION:

$Id: mysql.sql 13 2009-03-24 05:15:27Z boomfish $

ORIGINAL VERSION INFORMATION:

This file was part of Model-Glue Model-Glue: ColdFusion (2.0.304).

The version number in parenthesis is in the format versionNumber.subversion.revisionNumber.
 */

DROP TABLE IF EXISTS `Widget`;
CREATE TABLE `Widget` (
  `widgetId` int(11) NOT NULL auto_increment,
  `name` varchar(50) NOT NULL,
  `widgetTypeId` int(11) NOT NULL,
  `isActive` tinyint(1) NOT NULL,
  `widgetColourId` int(11) NULL,
  `orderDate` datetime NULL,
  `shipDate` datetime NULL,
  `quantity` int(11) NULL,
  `dateLastUpdated` datetime NOT NULL,
  PRIMARY KEY  (`widgetId`)
) ENGINE=MyISAM AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `WidgetCategory`;
CREATE TABLE `WidgetCategory` (
  `WidgetCategoryId` int(11) NOT NULL auto_increment,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY  (`WidgetCategoryId`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `WidgetType`;
CREATE TABLE `WidgetType` (
  `WidgetTypeId` int(11) NOT NULL auto_increment,
  `name` varchar(50) NOT NULL,
  `entryDate` datetime NULL,
  `dateLastUpdated` datetime NOT NULL,
  PRIMARY KEY  (`WidgetTypeId`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `WidgetColour`;
CREATE TABLE `WidgetColour` (
  `WidgetColourId` int(11) NOT NULL auto_increment,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY  (`WidgetColourId`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `Widget_WidgetCategory`;
CREATE TABLE `Widget_WidgetCategory` (
  `WidgetWidgetCategoryId` int(11) NOT NULL auto_increment,
  `WidgetId` int(11) NOT NULL,
  `WidgetCategoryId` int(11) NOT NULL,
  PRIMARY KEY  (`WidgetWidgetCategoryId`)
) ENGINE=MyISAM AUTO_INCREMENT=40 DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `WidgetAuditLog`;
CREATE TABLE `WidgetAuditLog` (
  `widgetAuditLogId` int(11) NOT NULL auto_increment,
  `eventDateTime` datetime NOT NULL,
  `message` varchar(50) NOT NULL,
  `detail` varchar(200) NULL,
  `remoteAddress` varchar(15) NULL,
  `sessionId` char(20) NULL,
  PRIMARY KEY  (`widgetAuditLogId`)
) ENGINE=MyISAM AUTO_INCREMENT=40 DEFAULT CHARSET=utf8;