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

$Id: CompareStrategyDate.cfc 7 2009-03-13 06:00:31Z boomfish $
--->
<cfcomponent output="false"	hint="I compare pairs of values as dates using the builtin DateCompare() function.">
	
	<cffunction name="compare2values" returntype="numeric" output="false" access="public" hint="Return the result of comparing two values, in the same manner as the Compare() builtin function">
		<cfargument name="value1" type="string" required="true" hint="The first value to compare" />
		<cfargument name="value2" type="string" required="true" hint="The first value to compare" />
		<cfargument name="args" type="struct" required="false" default="#structNew()#" hint="The additional arguments necessary to compare the data" />
		
		<cfset var local = StructNew() />
		
		<!--- Default datepart is second --->
		<cfset local.datePart = "s" />

		<!--- Use the datepart value in the args collection if provided --->		
		<cfif StructKeyExists(arguments.args,"datepart")>
			<cfif ListFindNoCase("s,n,h,d,m,yyyy",arguments.args.datepart)>
				<cfset local.datePart = arguments.args.datePart />
			<cfelse>
				<cfthrow type="validat.invalidArgs" message="validat: The compare strategy 'compareStrategyDate' argument 'datePart' contains a value that is not a valid date part." />
			</cfif>
		</cfif>

		<!--- Compare the dates --->
		<cfreturn DateCompare(arguments.value1,arguments.value2,local.datePart) />
	</cffunction>

</cfcomponent>