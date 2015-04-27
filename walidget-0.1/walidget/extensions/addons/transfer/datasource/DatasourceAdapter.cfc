<!---
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

This file was derived from /ModelGlue/Bean/CommonBeans/Datasource.cfc.

MODIFIED VERSION INFORMATION:

$Id: DatasourceAdapter.cfc 7 2009-03-13 06:00:31Z boomfish $

ORIGINAL VERSION INFORMATION:

This file was part of Model-Glue Model-Glue: ColdFusion (2.0.304).

The version number in parenthesis is in the format versionNumber.subversion.revisionNumber.
--->
<cfcomponent output="false" hint="I am a Datasource CFC adapter for a Transfer ORM Factory.">

	<cffunction name="Init" access="public" output="false" hint="Build a new adapter bean.">
		<cfargument name="transferFactory" type="any" required="true" />
		
		<cfset variables.instance = StructNew() />
		<cfset instance.transferDatasource = arguments.transferFactory.getDatasource() />
		<cfreturn this />
	</cffunction>
  
	<cffunction name="GetDSN" access="public" return="string" output="false" hint="Get property: DSN">
		<cfreturn instance.transferDatasource.getName() />
	</cffunction>
	
	<cffunction name="GetUsername" access="public" return="string" output="false" hint="Get property: Username">
		<cfreturn instance.transferDatasource.getUserName() />
	</cffunction>
	
	<cffunction name="GetPassword" access="public" return="string" output="false" hint="Get property: Password">
		<cfreturn instance.transferDatasource.getPassword() />
	</cffunction>
  
</cfcomponent>