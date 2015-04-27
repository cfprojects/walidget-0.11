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

$Id: ColdSpringApplication.cfc 11 2009-03-21 16:05:52Z boomfish $
--->
<cfcomponent output="false" hint="I am a application.cfc base component for an application that uses a ColdSpring bean factory in its application scope">

	<!---
		To use this CFC in your application, follow these steps:

			1. Change the cfcomponent tag in your Application.cfc to extend this CFC.
			2. Copy the cfscript code below into your Application.cfc (outside of any cffunction tags).
			3. Modify the values in the copied cfscript code to suit your application.
			4. If your Application.cfc defines onApplicationStart() and/or onRequestStart(),
				edit them to call super.onApplicationStart() and/or super.onRequestStart() respectively.
	
		<cfscript>
			// Variables for setting up ColdSpring for this application
			
			// Name for the bean factory variable in the application scope
			variables.beanFactoryVariableName = "beanFactory";
			// Path to ColdSpring.xml file
			variables.beanFactoryConfigFilePath = ExpandPath("/full/path/to/app/ColdSpring.xml");
			// Should the bean factory construct non-lazy beans on initialization?
			variables.beanFactoryConstructNonLazyBeans = true;
			// URL key and value for reloading the bean factory
			variables.beanFactoryReloadKey = "init";
			variables.beanFactoryReloadPassword = "true";
		</cfscript>
	--->

	<!--- Public Application.cfc methods --->
	
	<cffunction name="onApplicationStart" returntype="boolean" access="public" output="false">
		<!--- Initial setup of core bean factory --->
		<cfif beanFactoryConfigExists()>
			<cfset setupBeanFactory() />
		</cfif>
		<cfreturn true />
	</cffunction>
	
	<cffunction name="onRequestStart" returntype="boolean" access="public" output="false">
		<cfargument name="targetPage" type="String" required="true" />

		<cfif beanFactoryConfigExists()>
			<!--- If bean factory reload key and password are provided, recreate the bean factory --->
			<cfif (not beanFactoryExists())
					or (
						StructKeyExists(url, this.beanFactoryConfig.reloadKey)
						and url[this.beanFactoryConfig.reloadKey] eq this.beanFactoryConfig.reloadPassword
					)>
				<cfset setupBeanFactory() />
			</cfif>
		</cfif>
		<cfreturn true />
	</cffunction>
	
	<!--- Private methods for managing the application-scope bean factory --->

	<cffunction name="setupBeanFactory" returntype="void" access="private" output="false" hint="Set up the bean factory in the application scope">
		<!--- Create and initialize the bean factory --->
		<cfset var beanFactory = CreateObject('component', 'coldspring.beans.DefaultXmlBeanFactory').init() />
		<cfset beanFactory.loadBeans(this.beanFactoryConfig.definitionFilePath, this.beanFactoryConfig.constructNonLazyBeans) />
		<!--- Put the fully loaded bean factory in the application scope --->
		<cfset application[this.beanFactoryConfig.applicationVariableName] = beanFactory />
	</cffunction>

	<cffunction name="beanFactoryConfigExists" returntype="boolean" access="private" output="false" hint="Does the bean factory configuration exist?">
		<cfreturn StructKeyExists(this,"beanFactoryConfig") />
	</cffunction>

	<cffunction name="beanFactoryExists" returntype="boolean" access="private" output="false" hint="Does the bean factory exist in the application scope?">
		<cfreturn StructKeyExists(application,this.beanFactoryConfig.applicationVariableName) />
	</cffunction>

</cfcomponent>