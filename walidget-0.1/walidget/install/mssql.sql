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

This file was derived from /modelgluesamples/Widget/install/mssql.sql.

MODIFIED VERSION INFORMATION:

$Id: mssql.sql 13 2009-03-24 05:15:27Z boomfish $

ORIGINAL VERSION INFORMATION:

This file was part of Model-Glue Model-Glue: ColdFusion (2.0.304).

The version number in parenthesis is in the format versionNumber.subversion.revisionNumber.
 */

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Widget_WidgetCategory_Widget]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Widget_WidgetCategory] DROP CONSTRAINT FK_Widget_WidgetCategory_Widget
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Widget_WidgetCategory_WidgetCategory]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Widget_WidgetCategory] DROP CONSTRAINT FK_Widget_WidgetCategory_WidgetCategory
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FK_Widget_WidgetType]') and OBJECTPROPERTY(id, N'IsForeignKey') = 1)
ALTER TABLE [dbo].[Widget] DROP CONSTRAINT FK_Widget_WidgetType
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Widget]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Widget]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[WidgetCategory]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[WidgetCategory]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[WidgetType]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[WidgetType]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[WidgetColour]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[WidgetColour]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Widget_WidgetCategory]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Widget_WidgetCategory]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[WidgetAuditLog]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[WidgetAuditLog]
GO

CREATE TABLE [dbo].[Widget] (
	[widgetId] [int] IDENTITY (1, 1) NOT NULL ,
	[name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[widgetTypeId] [int] NOT NULL ,
	[isActive] [bit] NOT NULL , 
	[orderDate] [datetime] NULL ,
	[shipDate] [datetime] NULL ,
	[quantity] [int] NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[WidgetCategory] (
	[WidgetCategoryId] [int] IDENTITY (1, 1) NOT NULL ,
	[name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[WidgetType] (
	[WidgetTypeId] [int] IDENTITY (1, 1) NOT NULL ,
	[name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[WidgetColour] (
	[WidgetColourId] [int] IDENTITY (1, 1) NOT NULL ,
	[name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Widget_WidgetCategory] (
	[WidgetWidgetCategoryId] [int] IDENTITY (1, 1) NOT NULL ,
	[WidgetId] [int] NOT NULL ,
	[WidgetCategoryId] [int] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[WidgetAuditLog] (
	[widgetAuditLogId] [int] IDENTITY (1, 1) NOT NULL ,
	[eventDateTime] [datetime] NOT NULL ,
	[message] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[detail] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[remoteAddress] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[sessionId] [char] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO


ALTER TABLE [dbo].[Widget] ADD 
	CONSTRAINT [PK_Widget] PRIMARY KEY  CLUSTERED 
	(
		[widgetId]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[WidgetCategory] ADD 
	CONSTRAINT [PK_WidgetCategory] PRIMARY KEY  CLUSTERED 
	(
		[WidgetCategoryId]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[WidgetType] ADD 
	CONSTRAINT [PK_WidgetType] PRIMARY KEY  CLUSTERED 
	(
		[WidgetTypeId]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[WidgetColour] ADD 
	CONSTRAINT [PK_WidgetColour] PRIMARY KEY  CLUSTERED 
	(
		[WidgetColourId]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Widget_WidgetCategory] ADD 
	CONSTRAINT [PK_Widget_WidgetCategory] PRIMARY KEY  CLUSTERED 
	(
		[WidgetWidgetCategoryId]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Widget] ADD 
	CONSTRAINT [FK_Widget_WidgetType] FOREIGN KEY 
	(
		[widgetTypeId]
	) REFERENCES [dbo].[WidgetType] (
		[WidgetTypeId]
	),
	CONSTRAINT [FK_Widget_WidgetColour] FOREIGN KEY 
	(
		[widgetColourId]
	) REFERENCES [dbo].[WidgetColour] (
		[WidgetColourId]
	)
GO

ALTER TABLE [dbo].[Widget_WidgetCategory] ADD 
	CONSTRAINT [FK_Widget_WidgetCategory_Widget] FOREIGN KEY 
	(
		[WidgetId]
	) REFERENCES [dbo].[Widget] (
		[widgetId]
	),
	CONSTRAINT [FK_Widget_WidgetCategory_WidgetCategory] FOREIGN KEY 
	(
		[WidgetCategoryId]
	) REFERENCES [dbo].[WidgetCategory] (
		[WidgetCategoryId]
	)
GO

ALTER TABLE [dbo].[WidgetAuditLog] ADD 
	CONSTRAINT [PK_WidgetAuditLog] PRIMARY KEY  CLUSTERED 
	(
		[widgetAuditLogId]
	)  ON [PRIMARY] 
GO

