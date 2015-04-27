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

$Id: ValidateCfIsValid.cfc 14 2009-08-07 04:18:09Z boomfish $
--->
<cfcomponent
	displayname="validateCfIsValid"
	output="false"
	hint="Validation rule using the ColdFusion IsValid() builtin function."
	extends="validat.validationRules.validator">
	
	<!--- ------------------------------------------------------------ --->
	<!--- constructor --->

	<cffunction name="init" access="public" returntype="validateCfIsValid"
		hint="The default constructor for the validator rule, returning the initialized validator rule instance">

		<!--- call the base constructor --->
		<cfset super.init() />
			
		<!--- return the initialized validation rule --->
		<cfreturn this />	
	</cffunction> <!--- end: init() --->
	
	<!--- ------------------------------------------------------------ --->
	<!--- public methods --->

	<!--- 
		function: 		validate
	
		description:	Check to see if the data value is valid according to ColdFusion's IsValid() builtin function.
		
		arguments:		type ( validation type used by IsValid() )
						min ( for type=range, the minimum value )
						max ( for type=range, the maximum value )
						pattern ( for type=regex, the regular expression pattern )
	--->
	<cffunction name="validate" access="public" output="false" returntype="string"
		hint="Check to see if the data value is valid according to ColdFusion's IsValid() builtin function.">

		<cfargument name="data" type="any" required="true" hint="The data to be validated" />
		<cfargument name="args" type="struct" required="false" default="#structNew()#" hint="The addtional arguments necessary to validate the data" />
		<cfargument name="dependencies" type="struct" required="false" default="#structNew()#" hint="The additional dependencies necessary to validate the data" />		
		
		<!--- check to see if a type was provided in the arguments collection --->
		<cfif NOT structKeyExists( arguments.args, 'type' ) >
			<cfthrow type="validat.missingArgs" message="validat: The validation rule 'validateCfIsValid' requires argument 'type'." />
		</cfif>
				
		<!--- validate data based upon the type mask --->
		<cfswitch expression="#lcase(arguments.args.type)#">

			<cfcase value="range">

				<!--- check to see if a min and max was provided in the arguments collection --->
				<cfif NOT structKeyExists( arguments.args, 'min' ) OR NOT structKeyExists( arguments.args, 'max' )>
					<cfthrow type="validat.missingArgs" message="validat: The validation rule 'validateCfIsValid' type 'range' requires additional arguments 'min' and 'max'." />
				</cfif>
				
				<cfif IsValid( arguments.args.type , arguments.data, arguments.args.min, arguments.args.max )>
					<cfreturn true /> <!--- valid --->
				</cfif>
			</cfcase>

			<cfcase value="regex,regular_expression">

				<!--- check to see if a pattern was provided in the arguments collection --->
				<cfif NOT structKeyExists( arguments.args, 'pattern' )>
					<cfthrow type="validat.missingArgs" message="validat: The validation rule 'validateCfIsValid' type 'regex' requires additional argument 'pattern'." />
				</cfif>
					
				<cfif IsValid( arguments.args.type , arguments.data , arguments.args.pattern )>
					<cfreturn true /> <!--- valid --->
				</cfif>
			</cfcase>
		

			<cfdefaultcase>
				
				<!--- Assume the value of type is supported by the IsValid() function --->
				<cfif IsValid( arguments.args.type , arguments.data )>
					<cfreturn true /> <!--- valid --->
				</cfif>
				
			</cfdefaultcase>
		
		</cfswitch>

		<cfreturn "invalid" />
	</cffunction> <!--- end: validate() --->

</cfcomponent>