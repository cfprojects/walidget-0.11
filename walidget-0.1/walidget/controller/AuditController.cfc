<!---
COPYRIGHT INFORMATION:

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

VERSION INFORMATION:

$Id: AuditController.cfc 7 2009-03-13 06:00:31Z boomfish $
--->
<cfcomponent name="AuditController" hint="I record auditable events" extends="ModelGlue.unity.controller.Controller">

	<!--- Methods for getting beans / dependencies --->

	<cffunction name="getAuditService" access="private" returnType="any" output="false" hint="Return the audit service">
		<cfreturn getModelGlue().getBean("auditService") />
	</cffunction>

	<cffunction name="getStructLib" access="private" returnType="any" output="false" hint="Return a structure function library">
		<cfreturn getModelGlue().getBean("structLib") />
	</cffunction>

	<cffunction name="getModelGlueConfiguration" access="private" returnType="any" output="false" hint="Return the Model-Glue configuration">
		<cfreturn getModelGlue().getBean("modelGlueConfiguration") />
	</cffunction>

	<!--- Message listener methods --->

	<cffunction name="logRequestStart" access="public" output="false" returntype="void" hint="Log information about the current request.">
		<cfargument name="event" type="any" />
		<cfset var local = StructNew() />
		
		<!--- Log the request start --->
		<cfset getAuditService().audit(
							message="Request: " & arguments.event.getValue("event"),
							detail="Request started (method=#CGI.REQUEST_METHOD#)") />
							

		<!--- If this request forced a reload of the framework, log the fact --->
		<cfset local.modelGlueConfig = getModelGlueConfiguration() />
		<cfif StructKeyExists(url,local.modelGlueConfig.getReloadKey()) and (url[local.modelGlueConfig.getReloadKey()] eq local.modelGlueConfig.getReloadPassword())>
			<cfset getAuditService().audit(
							message="ModelGlue: Reload",
							detail="The Model-Glue framework has been reloaded") />
		</cfif>	
	</cffunction>
	
	<cffunction name="logEvent" access="public" output="false" returntype="void" hint="Log information about the current event.">
		<cfargument name="event" type="any" />
		
		<cfset var local = StructNew() />
				
		<cfset local.logDetail = arguments.event.getArgument("detail") />
		<cfset local.propertyList = arguments.event.getArgument("properties") />
		
		<!--- If we have a property list, append their name/value pairs to the detail string --->
		<cfif ListLen(local.propertyList)>
			<cfset local.logDetail = local.logDetail & " (" & getStructLib().structToList(arguments.event.getAllValues(),local.propertyList) & ")" />
		</cfif>	

		<cfset getAuditService().audit(
							message="Event: " & arguments.event.getEventHandlerName(),
							detail=local.logDetail) />
	</cffunction>
	
	<cffunction name="logError" access="public" output="false" returntype="void" hint="Log information about the current error.">
		<cfargument name="event" type="any" />
		
		<cfset var exception = arguments.event.getValue("exception") />

		<cfset getAuditService().audit(
							message="Error: " & arguments.event.getValue("event"),
							detail="Exception (message=#exception.message#)") />
	</cffunction>

</cfcomponent>