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

$Id: StructLib.cfc 7 2009-03-13 06:00:31Z boomfish $
--->
<cfcomponent hint="I provide structure library functions" output="false">
		
	<cffunction name="populateBeanFromStruct" access="public" output="false" returntype="void" hint="Populate a bean CFC from values in a structure.">
		<cfargument name="bean" type="any" required="true" hint="The CFC bean instance to populate" />
		<cfargument name="structure" type="struct" required="true" hint="The structure to use to populate the bean" />
		<cfargument name="fieldList" type="string" required="false" default="#structKeyList(arguments.structure)#" hint="The [optional] list of fields to copy from the structure to the bean." />
		
		<cfset var local = StructNew() />
				
		<cfloop index="local.fieldName" list="#arguments.fieldList#">
			<cfset local.propertySetterMethod = "set" & local.fieldName />
			<cfif structKeyExists(arguments.bean, local.propertySetterMethod) and structKeyExists(arguments.structure, local.fieldName)>
				<cfinvoke component="#arguments.bean#" method="#local.propertySetterMethod#">
					<cfinvokeargument name="#local.fieldName#" value="#arguments.structure[local.fieldName]#" />
				</cfinvoke>
			</cfif>
		</cfloop>
		
		<cfreturn />
	</cffunction>
	
	<cffunction name="structToList" access="public" output="false" returntype="string" hint="Convert a structure into a list of delimited key/value pairs.">
		<cfargument name="structure" type="struct" required="true" hint="Structure to convert" />
		<cfargument name="keyList" type="string" required="false" default="#StructKeyList(arguments.structure)#" hint="List of keys to convert in order" />
		<cfargument name="outerDelimiter" type="string" required="false" default="," hint="String used to separate list elements" />
		<cfargument name="innerDelimiter" type="string" required="false" default="=" hint="String used to separate a key and its value" />
		<cfargument name="keyListDelimiter" type="string" required="false" default="," hint="Delimiter for key list" />
		
		<cfset var local = StructNew() />
		
		<cfset local.resultArray = ArrayNew(1) />
		<cfloop index="local.structKey" list="#arguments.keyList#" delimiters="#arguments.keyListDelimiter#">
			<cfif StructKeyExists(arguments.structure, local.structKey)>
				<cfset ArrayAppend(local.resultArray, local.structKey & arguments.innerDelimiter & arguments.structure[local.structKey]) />
			</cfif>
		</cfloop>
		
		<cfreturn ArrayToList(local.resultArray, arguments.outerDelimiter) />
	</cffunction>

</cfcomponent>