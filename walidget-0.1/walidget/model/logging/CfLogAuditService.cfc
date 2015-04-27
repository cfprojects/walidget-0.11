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

$Id: CfLogAuditService.cfc 7 2009-03-13 06:00:31Z boomfish $
--->
<cfcomponent hint="I accept audit message and record them using the CFLOG tag." output="false">

	<cfproperty name="auditFileName" hint="Name of the file for logging messages" type="string" />

	<cffunction name="init" access="public" output="false">
		<cfset variables.instance = StructNew() />
		<cfreturn this />
	</cffunction>

	<cffunction name="getAuditFileName" access="public" output="false" returntype="string">
		<cfreturn instance.auditFileName />
	</cffunction>

	<cffunction name="setAuditFileName" access="public" output="false" returntype="void">
		<cfargument name="auditFileName" type="string" required="true" />
		<cfset instance.auditFileName = arguments.auditFileName />
	</cffunction>

	<cffunction name="audit" access="public" output="false" returntype="void" hint="Record a message in the audit log.">
		<cfargument name="message" type="string" required="true" hint="Terse description of event" />
		<cfargument name="detail" type="string" required="false" default="" hint="Detailed description of event" />

		<cflog file="#getAuditFileName()#" text="#arguments.message#; Detail: #arguments.detail#" />
		
	</cffunction>
	
</cfcomponent>
