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

$Id: AuditServiceConfiguration.cfc 11 2009-03-21 16:05:52Z boomfish $
--->
<cfcomponent hint="I contain the configuration for a DB audit service.">

	<cfproperty name="datasource" hint="Datasource bean" type="any" />
	<cfproperty name="tableName" hint="Name of the database table for logging messages" type="string" />
	<cfproperty name="timestampColumnName" hint="Name of event timestamp column in the audit table (must be a cf_sql_timestamp type); if not set, timestamp is not explicitly logged" type="string" />
	<cfproperty name="sessionIdColumnName" hint="Name of session ID column in the audit table (must be a cf_sql_char or cf_sql_varchar type); if not set, session ID is not logged" type="string" />
	<cfproperty name="maxSessionIdLength" hint="Maximum length of the session ID column in the audit table" type="numeric" />
	<cfproperty name="remoteAddressColumnName" hint="Name of remote address column in the audit table (must be a cf_sql_char or cf_sql_varchar type); if not set, remote address is not logged" type="string" />
	<cfproperty name="maxRemoteAddressLength" hint="Maximum length of the remote address column in the audit table" type="numeric" />
	<cfproperty name="messageColumnName" hint="Name of the message column in the audit table (must be a cf_sql_char or cf_sql_varchar type)" type="string" />
	<cfproperty name="maxMessageLength" hint="Maximum length of the message column in the audit table" type="numeric" />
	<cfproperty name="detailColumnName" hint="Name of the detail column in the audit table (must be a cf_sql_char or cf_sql_varchar type); if not set, detail is not logged" type="string" />
	<cfproperty name="maxDetailLength" hint="Maximum length of the detail column in the audit table" type="numeric" />

	<cffunction name="init" access="public" output="false">
		<cfset instance = StructNew() />
		<cfscript>
			// Set defaults for non-required properties
			setMaxMessageLength(100);
			setSessionIdColumnName("");
			setMaxSessionIdLength(30);
			setRemoteAddressColumnName("");
			setMaxRemoteAddressLength(15);
			setDetailColumnName("");
			setMaxDetailLength(100);
		</cfscript>
		<cfreturn this />
	</cffunction>

	<cffunction name="setDatasource" access="public" output="false" returntype="void">
		<cfargument name="datasource" type="any" required="true" />
		<cfset instance.datasource = arguments.datasource />
		<cfreturn />
	</cffunction>

	<cffunction name="getDatasource" access="public" output="false" returntype="any">
		<cfreturn instance.datasource />
	</cffunction>

	<cffunction name="setTableName" access="public" output="false" returntype="void">
		<cfargument name="tableName" type="string" required="true" />
		<cfset instance.tableName = arguments.tableName />
		<cfreturn />
	</cffunction>

	<cffunction name="getTableName" access="package" output="false" returntype="string">
		<cfreturn instance.tableName />
	</cffunction>

	<cffunction name="setTimestampColumnName" access="public" output="false" returntype="void">
		<cfargument name="timestampColumnName" type="string" required="true" />
		<cfset instance.timestampColumnName = arguments.timestampColumnName />
		<cfreturn />
	</cffunction>

	<cffunction name="getTimestampColumnName" access="package" output="false" returntype="string">
		<cfreturn instance.timestampColumnName />
	</cffunction>

	<cffunction name="getIncludeTimestamp" access="package" output="false" returntype="boolean">
		<cfreturn Len(instance.timestampColumnName) />
	</cffunction>

	<cffunction name="setRemoteAddressColumnName" access="public" output="false" returntype="void">
		<cfargument name="remoteAddressColumnName" type="string" required="true" />
		<cfset instance.remoteAddressColumnName = arguments.remoteAddressColumnName />
		<cfreturn />
	</cffunction>

	<cffunction name="getRemoteAddressColumnName" access="package" output="false" returntype="string">
		<cfreturn instance.remoteAddressColumnName />
	</cffunction>

	<cffunction name="getIncludeRemoteAddress" access="package" output="false" returntype="boolean">
		<cfreturn Len(instance.remoteAddressColumnName) />
	</cffunction>

	<cffunction name="setMaxRemoteAddressLength" access="public" output="false" returntype="void">
		<cfargument name="maxRemoteAddressLength" type="numeric" required="true" />
		<cfset instance.maxRemoteAddressLength = arguments.maxRemoteAddressLength />
	</cffunction>

	<cffunction name="getMaxRemoteAddressLength" access="package" output="false" returntype="numeric">
		<cfreturn instance.maxRemoteAddressLength />
	</cffunction>

	<cffunction name="setSessionIdColumnName" access="public" output="false" returntype="void">
		<cfargument name="sessionIdColumnName" type="string" required="true" />
		<cfset instance.sessionIdColumnName = arguments.sessionIdColumnName />
	</cffunction>

	<cffunction name="getSessionIdColumnName" access="package" output="false" returntype="string">
		<cfreturn instance.sessionIdColumnName />
	</cffunction>

	<cffunction name="getIncludeSessionId" access="package" output="false" returntype="boolean">
		<cfreturn Len(instance.sessionIdColumnName) />
	</cffunction>

	<cffunction name="setMaxSessionIdLength" access="public" output="false" returntype="void">
		<cfargument name="maxSessionIdLength" type="numeric" required="true" />
		<cfset instance.maxSessionIdLength = arguments.maxSessionIdLength />
	</cffunction>

	<cffunction name="getMaxSessionIdLength" access="package" output="false" returntype="numeric">
		<cfreturn instance.maxSessionIdLength />
	</cffunction>

	<cffunction name="setMessageColumnName" access="public" output="false" returntype="void">
		<cfargument name="messageColumnName" type="string" required="true" />
		<cfset instance.messageColumnName = arguments.messageColumnName />
	</cffunction>

	<cffunction name="getMessageColumnName" access="package" output="false" returntype="string">
		<cfreturn instance.messageColumnName />
	</cffunction>

	<cffunction name="setMaxMessageLength" access="public" output="false" returntype="void">
		<cfargument name="maxMessageLength" type="numeric" required="true" />
		<cfset instance.maxMessageLength = arguments.maxMessageLength />
	</cffunction>

	<cffunction name="getMaxMessageLength" access="package" output="false" returntype="numeric">
		<cfreturn instance.maxMessageLength />
	</cffunction>

	<cffunction name="setDetailColumnName" access="public" output="false" returntype="void">
		<cfargument name="detailColumnName" type="string" required="true" />
		<cfset instance.detailColumnName = arguments.detailColumnName />
	</cffunction>

	<cffunction name="getDetailColumnName" access="package" output="false" returntype="string">
		<cfreturn instance.detailColumnName />
	</cffunction>

	<cffunction name="getIncludeDetail" access="package" output="false" returntype="boolean">
		<cfreturn Len(instance.detailColumnName) />
	</cffunction>

	<cffunction name="setMaxDetailLength" access="public" output="false" returntype="void">
		<cfargument name="maxDetailLength" type="numeric" required="true" />
		<cfset instance.maxDetailLength = arguments.maxDetailLength />
	</cffunction>

	<cffunction name="getMaxDetailLength" access="package" output="false" returntype="numeric">
		<cfreturn instance.maxDetailLength />
	</cffunction>
	
</cfcomponent>
