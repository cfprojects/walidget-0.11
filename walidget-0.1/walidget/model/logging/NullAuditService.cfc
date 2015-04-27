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

$Id: NullAuditService.cfc 7 2009-03-13 06:00:31Z boomfish $
--->
<cfcomponent hint="I accept audit messages and do absolutely nothing with them." output="false">

	<cffunction name="audit" access="public" output="false" returntype="void" hint="Accept an audit message.">
		<cfargument name="message" type="string" required="true" hint="Terse description of event" />
		<cfargument name="detail" type="string" required="false" default="" hint="Detailed description of event" />

		<cfreturn />
	</cffunction>
	
</cfcomponent>
