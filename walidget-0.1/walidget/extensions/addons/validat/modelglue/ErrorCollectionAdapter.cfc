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

$Id: ErrorCollectionAdapter.cfc 7 2009-03-13 06:00:31Z boomfish $
--->
<cfcomponent extends="ModelGlue.Util.ValidationErrorCollection" output="false" hint="I am a ValidationErrorCollection adapter for a Validat errorCollection.">

	<cffunction name="Init" access="public" output="false" hint="Constructor">
	  <cfset variables.instance = structNew() />
	  <cfreturn this />
	</cffunction>
		
	<cffunction name="setValidatErrorCollection" access="public" output="false" returntype="void" hint="Set the validat error collection under this adapter.">
		<cfargument name="validatErrorCollection" type="any" required="true" />
		<cfset instance.validatErrorCollection = arguments.validatErrorCollection />
		<cfreturn />
	</cffunction>

	<cffunction name="getValidatErrorCollection" access="public" output="false" returntype="any" hint="Return the validat error collection under this adapter.">
		<cfreturn instance.validatErrorCollection />
	</cffunction>
	
	<cffunction name="AddError" returntype="void" access="public" output="false" hint="Add an error to the collection.">
	  <cfargument name="PropertyName" type="string" required="true" hint="The property in an error state">
	  <cfargument name="ErrorMessage" type="any" required="true" hint="A friendly error message (may be complex)">
	
		<cfset instance.validatErrorCollection.addError(dataElement=arguments.PropertyName, message=arguments.ErrorMessage) />
	</cffunction>
	
	<cffunction name="GetErrors" returntype="struct" access="public" output="false" hint="Get the error collection">
	
		<cfset var local = StructNew() />
		
		<cfset local.validatErrorStruct = instance.validatErrorCollection.getErrors() />
		<cfset local.mgErrorStruct = StructNew() />
		
		<cfloop collection="#local.validatErrorStruct#" item="fieldName">
			<cfif IsStruct(local.validatErrorStruct[fieldName]) and StructKeyExists(local.validatErrorStruct[fieldName],"errors")>
				<cfset local.validatFieldErrors = local.validatErrorStruct[fieldName].errors />
				<cfset local.mgFieldErrors = ArrayNew(1) />
				<cfloop index="local.fieldErrorIndex" from="1" to="#ArrayLen(local.validatFieldErrors)#">
					<cfset ArrayAppend(local.mgFieldErrors, local.validatFieldErrors[local.fieldErrorIndex].message) />
				</cfloop>
				<cfset local.mgErrorStruct[fieldName] = local.mgFieldErrors />
			</cfif>
		</cfloop>
	
		<cfreturn local.mgErrorStruct />
		
	</cffunction>
	
	<cffunction name="HasErrors" returntype="boolean" access="public" output="false" hint="Returns true if there are errors, false otherwise.">
	  <cfargument name="PropertyName" type="string" required="false" default="" hint="If provided, limits the error check to a specific property">
	
	  <cfif len(arguments.propertyName)>
		<cfreturn instance.validatErrorCollection.hasErrors(dataElement=arguments.PropertyName) />
	  <cfelse>
		<cfreturn instance.validatErrorCollection.hasErrors() />
	  </cfif>
	</cffunction>

</cfcomponent>