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

$Id: ValidateCompare2.cfc 14 2009-08-07 04:18:09Z boomfish $
--->
<cfcomponent
	displayname="validateCompareExpr"
	output="false"
	hint="Validation rule to validate a value using a relational comparison (lt,lte,eq,neq,gte,gt) against an evaluated expression."
	extends="validateCompare2">
	
	<!--- ------------------------------------------------------------ --->
	<!--- constructor --->

	<cffunction name="init" access="public" returntype="validateCompareExpr"
		hint="The default constructor for the validator rule, returning the initialized validator rule instance">

		<cfargument name="compareStrategy" type="any" required="true" hint="The compare strategy to use for this validator" />

		<!--- call the base constructor --->
		<cfset super.init(arguments.compareStrategy) />
		
		<cfreturn this />	
	</cffunction> <!--- end: init() --->
	
	<!--- ------------------------------------------------------------ --->
	<!--- public methods --->

	<!--- 
		function: 		validate
	
		description:	Based upon the value for the operator argument and expression argument, check if the data value is valid.
	--->
	<cffunction name="validate" access="public" output="false" returntype="string"
		hint="Based upon the value for the operator argument and and expression argument, check if the data value is valid.">

		<cfargument name="data" type="any" required="true" hint="The data to be validated" />
		<cfargument name="args" type="struct" required="false" default="#structNew()#" hint="The addtional arguments necessary to validate the data" />
		<cfargument name="dependencies" type="struct" required="false" default="#structNew()#" hint="The additional dependencies necessary to validate the data" />
		
		<cfset var local = StructNew() />		
		
		<!--- check to see if expression was provided in the arguments collection --->
		<cfif NOT structKeyExists( arguments.args, 'expression' ) >
			<cfthrow type="validat.missingArgs" message="validat: The validation rule 'validateCompareExpr' requires an argument named 'expression' that specifies the expression to evaluate." />
		</cfif>
		
		<!--- Try to evaluate the expression --->
		<cftry>
			<cfset local.expressionValue = Evaluate(arguments.args.expression) />
			<cfcatch type="Any">
				<cfthrow type="validat.expression" message="#cfcatch.message#" />
			</cfcatch>
		</cftry>
		
		<!--- Use the evaluated value as the second value for validation --->
		<cfset arguments.dependencies.secondValue = local.expressionValue />
		
		<cfreturn super.validate(arguments.data, arguments.args, arguments.dependencies) />

	</cffunction> <!--- end: validate() --->

</cfcomponent>