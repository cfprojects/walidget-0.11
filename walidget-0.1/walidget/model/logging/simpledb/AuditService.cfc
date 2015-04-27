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

$Id: AuditService.cfc 11 2009-03-21 16:05:52Z boomfish $
--->
<cfcomponent output="false" hint="I accept audit messages and record them in a database table.">

	<cffunction name="init" access="public" output="false">
		<cfargument name="configuration" type="AuditServiceConfiguration" required="true" />
		<cfset variables.instance = StructNew() />
		<cfset instance.config = arguments.configuration />
		<cfreturn this />
	</cffunction>

	<!--- Bean properties / dependencies --->


	<!--- Public service methods --->
	
	<cffunction name="audit" access="public" output="false" returntype="void" hint="Record a message in the audit log table.">
		<cfargument name="message" type="string" required="true" hint="Terse description of event" />
		<cfargument name="detail" type="string" required="false" default="" hint="Detailed description of event" />
		<cfargument name="remoteAddress" type="string" required="false" default="#CGI.REMOTE_ADDR#" hint="Remote address to record with message" />
		<cfargument name="sessionId" type="string" required="false" hint="Session ID string to record with message, defaults to session.sessionId if sessionId is being logged" />
		
		<cfset var local = StructNew() />
		<cfset local.datasource = instance.config.getDatasource() />
		
		<cfif instance.config.getIncludeSessionId() and not StructKeyExists(arguments,"sessionId")>
			<!--- Default to J2EE session ID --->
			<cfset arguments.sessionId = session.sessionId />
		</cfif>

		<cfquery name="local.insertLog" datasource="#local.datasource.getDsn()#" username="#local.datasource.getUsername()#" password="#local.datasource.getPassword()#">
			INSERT INTO #instance.config.getTableName()#
				(
					#instance.config.getMessageColumnName()#
					<cfif instance.config.getIncludeTimestamp()>,#instance.config.getTimestampColumnName()#</cfif>
					<cfif instance.config.getIncludeRemoteAddress()>,#instance.config.getRemoteAddressColumnName()#</cfif>
					<cfif instance.config.getIncludeSessionId()>,#instance.config.getSessionIdColumnName()#</cfif>
					<cfif instance.config.getIncludeDetail()>,#instance.config.getDetailColumnName()#</cfif>
				 )
			VALUES
				(
					<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="#instance.config.getMaxMessageLength()#" value="#Left(arguments.message,instance.config.getMaxMessageLength())#" />
					<cfif instance.config.getIncludeTimestamp()>,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#" /></cfif>
					<cfif instance.config.getIncludeRemoteAddress()>,<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="#instance.config.getMaxRemoteAddressLength()#" value="#Left(arguments.remoteAddress,instance.config.getMaxRemoteAddressLength())#" /></cfif>
					<cfif instance.config.getIncludeSessionId()>,<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="#instance.config.getMaxSessionIdLength()#" value="#Left(arguments.sessionid,instance.config.getMaxSessionIdLength())#" /></cfif>
					<cfif instance.config.getIncludeDetail()>,<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="#instance.config.getMaxDetailLength()#" value="#Left(arguments.detail,instance.config.getMaxDetailLength())#" /></cfif>
				)
		</cfquery>
	</cffunction>
	
</cfcomponent>
