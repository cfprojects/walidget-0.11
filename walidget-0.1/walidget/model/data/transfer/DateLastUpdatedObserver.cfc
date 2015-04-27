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

$Id: DateLastUpdatedObserver.cfc 7 2009-03-13 06:00:31Z boomfish $
--->
<cfcomponent output="false" hint="Observer CFC that sets the DateLastUpdated property on Transfer objects prior to updates">

	<cffunction name="init" access="public" hint="This contructor method registers the observer with Transfer" output="false">
		<cfargument name="transfer" type="transfer.com.Transfer" required="true" />
				
		<cfset arguments.transfer.addBeforeUpdateObserver(this) />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="actionBeforeUpdateTransferEvent" hint="Act on an event before an update happens" access="public" returntype="void" output="false">
	    <cfargument name="event" type="transfer.com.events.TransferEvent" required="true" />

	    <cfset setTransferObjectDateLastUpdated(arguments.event.getTransferObject()) />
	</cffunction> 
	
	<cffunction name="setTransferObjectDateLastUpdated" hint="Set the DateLastUpdated property of a Transfer object if present" access="private" returntype="void" output="false">
	    <cfargument name="transferObject" type="transfer.com.TransferObject" required="true" />
	    
	    <cfif StructKeyExists(arguments.transferObject,"setDateLastUpdated")>
		    <cfset arguments.transferObject.setDateLastUpdated(Now()) />
		</cfif>
	</cffunction>
	
</cfcomponent>