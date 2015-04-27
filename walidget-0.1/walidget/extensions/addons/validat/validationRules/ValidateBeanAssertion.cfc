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

$Id: ValidateBeanAssertion.cfc 7 2009-03-13 06:00:31Z boomfish $
--->
<cfcomponent
	displayname="validateBeanAssertion"
	output="false"
	hint="Validation rule using a method from an assertion bean."
	extends="validat.validationRules.validator">
	
	<!--- ------------------------------------------------------------ --->
	<!--- constructor --->

	<cffunction name="init" access="public" returntype="validateBeanAssertion"
		hint="The default constructor for the validator rule, returning the initialized validator rule instance">

		<!--- call the base constructor --->
		<cfset super.init() />
			
		<!--- return the initialized validatoin rule --->
		<cfreturn this />	
	</cffunction> <!--- end: init() --->
	
	<!--- ------------------------------------------------------------ --->
	<!--- public methods --->

    <cffunction name="getAssertionBean" access="private" output="false" returntype="any" hint="Return the assertion bean">
        <cfreturn variables.instance.assertionBean />
    </cffunction>

    <cffunction name="setAssertionBean" access="public" output="false" returntype="void" hint="Set the assertion bean">
        <cfargument name="assertionBean" type="any" required="true" />
        <cfset variables.instance.assertionBean = arguments.assertionBean />
    </cffunction>

	<!--- 
		function: 		validate
	
		description:	Check to see if the data value is valid according to an assertion bean.
		
		arguments:		method ( name of method to invoke on assertion bean )
						dataArgName ( name of data argument, defaults to 'value' )
						expectedResult ( expected return value from assertion method, defaults to 'true')
	--->
	<cffunction name="validate" access="public" output="false" returntype="string"
		hint="Check to see if the data value is valid according to a method from an assertion bean.">

		<cfargument name="data" type="any" required="true" hint="The data to be validated" />
		<cfargument name="args" type="struct" required="false" default="#structNew()#" hint="The addtional arguments necessary to validate the data" />
		<cfargument name="dependencies" type="struct" required="false" default="#structNew()#" hint="The additional dependencies necessary to validate the data" />		
		
        <cfset var local = StructNew() />
        
        <!--- check to see if bean name was provided in the arguments collection --->
        <cfif NOT structKeyExists( arguments.args, 'method' ) >
            <cfthrow type="validat.missingArgs" message="validat: The validation rule 'validateBeanAssertion' requires an argument named 'method' that specifies the name of the assertion method." />
        </cfif>

        <cfif structKeyExists( arguments.args, 'dataArgName' ) >
            <cfset local.dataArgName = arguments.args.dataArgName />
        <cfelse>
            <cfset local.dataArgName = 'value' />
        </cfif>

        <cfif structKeyExists( arguments.args, 'expectedResult' ) >
            <cfset local.expectedResult = arguments.args.expectedResult />
        <cfelse>
            <cfset local.expectedResult = true />
        </cfif>
        
        <!--- Merge the args and dependencies to build an arguments collection for the assertion call --->
        <cfset local.stcAssertionArgs = StructCopy(arguments.args) />
        <cfset StructAppend(local.stcAssertionArgs, arguments.dependencies) />
        
        <!--- Remove the argument elements meant for this CFC --->
        <cfset StructDelete(local.stcAssertionArgs,"method") />
        <cfset StructDelete(local.stcAssertionArgs,"dataArgName") />
        <cfset StructDelete(local.stcAssertionArgs,"expectedResult") />

        <!--- Call the assertion method --->
        <cfinvoke component="#getAssertionBean()#" method="#arguments.args.method#"
                    argumentcollection="#local.stcAssertionArgs#" returnvariable="local.assertionResult">
              <cfinvokeargument name="#local.dataArgName#" value="#arguments.data#" />
        </cfinvoke>
                    
        <cfif not StructKeyExists(local,"assertionResult")>
            <cfthrow type="validat.assertionResultError" message="validat: The validation rule 'validateBeanAssertion' assertion method returned a NULL value." />
        </cfif>

        <cfif not IsSimpleValue(local.assertionResult)>
            <cfthrow type="validat.assertionResultError" message="validat: The validation rule 'validateBeanAssertion' assertion method returned a complex value." />
        </cfif>

        <cfif local.assertionResult eq local.expectedResult>
            <cfreturn "true" />
        </cfif>
        
        <cfreturn "invalid" />
	</cffunction> <!--- end: validate() --->

</cfcomponent>