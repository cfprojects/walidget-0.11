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
	displayname="validateCompare2"
	output="false"
	hint="Validation rule to validate a value using a relational comparison (lt,lte,eq,neq,gte,gt) against a second value."
	extends="validat.validationRules.validator">
	
	<!--- ------------------------------------------------------------ --->
	<!--- constructor --->

	<cffunction name="init" access="public" returntype="validateCompare2"
		hint="The default constructor for the validator rule, returning the initialized validator rule instance">

		<cfargument name="compareStrategy" type="any" required="true" hint="The compare strategy to use for this validator" />

		<!--- call the base constructor --->
		<cfset super.init() />
		
		<cfscript>
			// Create a structure that maps relational comparison operators to lists of valid results from a compare function
			instance.validCompareResults = StructNew();
			instance.validCompareResults["lt"] = "-1";
			instance.validCompareResults["lte"] = "-1,0";
			instance.validCompareResults["eq"] = "0";
			instance.validCompareResults["neq"] = "-1,1";
			instance.validCompareResults["gte"] = "0,1";
			instance.validCompareResults["gt"] = "1";
		</cfscript>

		<!--- check to see if the compare strategy argument is an object --->
		<cfif NOT isObject( arguments.compareStrategy ) >
			<cfthrow type="validat.invalidCompareStrategy" message="validat: The constructor for the validation rule 'validateCompare2*' was not given a valid compare strategy." />
		</cfif>

		<!--- Set the compare strategy  --->
		<cfset instance.compareStrategy = arguments.compareStrategy />
		
		<!--- return the initialized validation rule --->
		<cfreturn this />	
	</cffunction> <!--- end: init() --->
	
	<!--- ------------------------------------------------------------ --->
	<!--- public methods --->

	<!--- 
		function: 		validate
	
		description:	Based upon the value for the operator argument and secondValue dependency, check if the data value is valid.
	--->
	<cffunction name="validate" access="public" output="false" returntype="string"
		hint="Based upon the value for the operator argument and secondValue dependency, check if the data value is valid.">

		<cfargument name="data" type="any" required="true" hint="The data to be validated" />
		<cfargument name="args" type="struct" required="false" default="#structNew()#" hint="The addtional arguments necessary to validate the data" />
		<cfargument name="dependencies" type="struct" required="false" default="#structNew()#" hint="The additional dependencies necessary to validate the data" />
		
		<cfset var local = StructNew() />
		
		<!--- check to see if the data value represents a simple string value --->
		<cfif NOT isSimpleValue( arguments.data ) >
			<cfthrow type="validat.invalidData" message="validat: The validation rule 'validateCompare2*' only accepts simple data types for the first value." />
		</cfif>
		
		<!--- check to see if operator was provided in the arguments collection --->
		<cfif NOT structKeyExists( arguments.args, 'operator' ) >
			<cfthrow type="validat.missingArgs" message="validat: The validation rule 'validateCompare2*' requires an argument named 'operator' that specifies relational operator to use." />
		</cfif>

		<!--- check to see if the operator in the arguments collection has a valid value --->
		<cfif NOT structKeyExists( instance.validCompareResults, arguments.args.operator ) >
			<cfthrow type="validat.invalidArgs" message="validat: The validation rule 'validateCompare2*' argument 'operator' must have one of the following values: lt,lte,eq,neq,gte,gt." />
		</cfif>

		<!--- check to see if secondValue was provided in the dependencies collection --->
		<cfif NOT structKeyExists( arguments.dependencies, 'secondValue' ) >
			<cfthrow type="validat.missingDependency" message="validat: The validation rule 'validateCompare2*' depends upon a second value which was not received." />
		</cfif>

		<!--- check to see if the second value represents a simple string value --->
		<cfif NOT isSimpleValue( arguments.dependencies.secondValue ) >
			<cfthrow type="validat.invalidData" message="validat: The validation rule 'validateCompare2*' only accepts simple data types for the second value." />
		</cfif>

		<!--- Skip the comparison and return true if the first value is missing --->
		<cfif NOT len( arguments.data ) >
			<cfreturn "true" />
		</cfif>

		<!--- Skip the comparison if the second value is missing --->
		<cfif NOT len( arguments.dependencies.secondValue ) >
			<!--- Return the value of the 'ResultIfSecondValueMissing' arg (defaults to "invalid") --->
			<cfif StructKeyExists( arguments.args, 'ResultIfSecondValueMissing' ) >
				<cfreturn arguments.args.ResultIfSecondValueMissing />
			</cfif>
			<cfreturn "invalid" />
		</cfif>

		<!--- Perform the comparison --->
		<cfif validCompare2( arguments.data, arguments.dependencies.secondValue, arguments.args.operator, arguments.args ) >
			<cfreturn "true" />
		</cfif>
		
		<cfreturn "invalid" />
	</cffunction> <!--- end: validate() --->

	<!--- Private methods to support the validation --->
	
	<cffunction name="validCompare2" returntype="boolean" output="false" access="private" hint="Return true if the result of comparing two values is valid, or false otherwise.">
		<cfargument name="value1" type="string" required="true" hint="The first value to compare" />
		<cfargument name="value2" type="string" required="true" hint="The first value to compare" />
		<cfargument name="operator" type="string" required="true" hint="The relational operator for the comparison" />
		<cfargument name="args" type="struct" required="false" default="#structNew()#" hint="The additional arguments necessary to compare the data" />
		
		<cfset var local = StructNew() />
		
		<!--- Get the list of valid result values for the provided operator --->
		<cfset local.validResults = instance.validCompareResults[arguments.operator] />
		
		<!--- Get the result of the comparison of the two values --->
		<cfset local.compareResult = instance.compareStrategy.compare2Values(arguments.value1, arguments.value2, arguments.args) />
		
		<!--- Is the result in the list of valid results? --->
		<cfreturn ListFind(local.validResults,local.compareResult) />
	</cffunction>

</cfcomponent>