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

This file was derived from /modelgluesamples/Widget/transfer/controller/Contrroller.cfc.

MODIFIED VERSION INFORMATION:

$Id: RequestController.cfc 7 2009-03-13 06:00:31Z boomfish $

ORIGINAL VERSION INFORMATION:

This file was part of Model-Glue Model-Glue: ColdFusion (2.0.304).

The version number in parenthesis is in the format versionNumber.subversion.revisionNumber.
--->
<cfcomponent extends="ModelGlue.unity.controller.Controller" hint="I handle generic Model-Glue events for the application" output="false">

	<!--- 
		Any function set up to listen for the onRequestStart message happens before any of the <event-handlers>.
		This is a good place to put things like session defaults.
	--->
	<cffunction name="onRequestStart" access="public" returnType="void" output="false">
		<cfargument name="event" type="any">
	</cffunction>

	<!--- 
		Any function set up to listen for the onQueueComplete message happens after all event-handlers are
		finished running and before any views are rendered.  This is a good place to load constants (like UDF
		libraries) that the views may need.
	--->
	<cffunction name="onQueueComplete" access="public" returnType="void" output="false">
		<cfargument name="event" type="any">
		<!--- Put the view defaults and resource URLs in the request scope, to make them accessible to views --->
		<cfset request.viewDefaults = getModelGlue().getBean("viewDefaults") />
		<cfset request.resourceUrls = getModelGlue().getBean("resourceUrls") />
	</cffunction>

	<!--- 
		Any function set up to listen for the onRequestEnd message happens after views are rendered.
	--->
	<cffunction name="onRequestEnd" access="public" returnType="void" output="false">
		<cfargument name="event" type="any">

		<!--- Should we suppress ColdFusion's debug output? --->
		<cfif request.viewDefaults.getConfigSetting("suppressColdFusionDebugOutput")>
			<cfsetting showdebugoutput="false" />
		</cfif>
	</cffunction>


</cfcomponent>