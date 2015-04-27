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

$Id: validatFactory.cfc 15 2009-08-18 04:17:58Z boomfish $
--->
<cfcomponent hint="I am a factory that creates configured instances of the Validat object." output="false">

	<cfproperty name="engineConfigXmlPath" hint="Mapped path to ColdSpring XML file for validation engine beans" type="string" required="false" />
	<cfproperty name="engineBeanName" hint="Name of validation engine bean in ColdSpring XML file" type="string" required="false" />

	<cffunction name="init" access="public" output="false">
		<cfset variables.instance = StructNew() />
		<!--- Default is to use my own parent factory to create Validat's internal components --->
		<cfset setEngineConfigXmlPath("") />
		<!--- Default bean name for validation engine instances --->
		<cfset setEngineBeanName("ValidatInstance") />
		<!--- Do not enable factory hierarchy by default --->
		<cfset setFactoryHierarchyEnabled(false) />
		<cfreturn this />
	</cffunction>

	<cffunction name="getEngineConfigXmlPath" access="public" output="false" returntype="string">
		<cfreturn variables.instance.engineConfigXmlPath />
	</cffunction>

	<cffunction name="setEngineConfigXmlPath" access="public" output="false" returntype="void">
		<cfargument name="engineConfigXmlPath" type="string" required="true" />
		<cfset variables.instance.engineConfigXmlPath = arguments.engineConfigXmlPath />
		<cfreturn />
	</cffunction>

	<cffunction name="getEngineBeanName" access="public" output="false" returntype="string">
		<cfreturn variables.instance.engineBeanName />
	</cffunction>

	<cffunction name="setEngineBeanName" access="public" output="false" returntype="void">
		<cfargument name="engineBeanName" type="string" required="true" />
		<cfset variables.instance.engineBeanName = arguments.engineBeanName />
	</cffunction>

    <cffunction name="getFactoryHierarchyEnabled" access="public" output="false" returntype="boolean">
        <cfreturn variables.instance.factoryHierarchyEnabled />
    </cffunction>

    <cffunction name="setFactoryHierarchyEnabled" access="public" output="false" returntype="void">
        <cfargument name="factoryHierarchyEnabled" type="boolean" required="true" />
        <cfset variables.instance.factoryHierarchyEnabled = arguments.factoryHierarchyEnabled />
    </cffunction>

	<cffunction name="getBeanFactory" access="private" output="false" returntype="any" hint="Return the parent bean factory (which might not be the validation engine factory)">
		<cfreturn variables.instance.beanFactory />
	</cffunction>

	<cffunction name="setBeanFactory" access="public" output="false" returntype="void" hint="Set the parent bean factory (which might not be the validation engine factory)">
		<!--- The type of the beanFactory argument must be "coldspring.beans.BeanFactory" for ColdSpring to automatically set it --->
		<cfargument name="beanFactory" type="coldspring.beans.BeanFactory" required="true" />
		<cfset variables.instance.beanFactory = arguments.beanFactory />
	</cffunction>

	<cffunction name="getEngineBeanFactory" access="private" output="false" returntype="any" hint="Return the bean factory for the validation engine">
		<cfreturn variables.instance.engineBeanFactory />
	</cffunction>

	<cffunction name="setEngineBeanFactory" access="private" output="false" returntype="void" hint="Set the bean factory for the validation engine">
		<cfargument name="engineBeanFactory" type="any" required="true" />
		<cfset variables.instance.engineBeanFactory = arguments.engineBeanFactory />
	</cffunction>

	<cffunction name="hasEngineBeanFactory" access="private" output="false" returntype="boolean" hint="Return whether a bean factory for the validation engine has been set up">
		<cfreturn StructKeyExists(variables.instance,"engineBeanFactory") />
	</cffunction>

	<cffunction name="getEngineInstance" access="private" output="false" returntype="any" hint="Return an unconfigured instance of the validation engine">
		<!--- Set up the bean factory if required --->
		<cfif not hasEngineBeanFactory()>
			<cfset setupEngineBeanFactory() />
		</cfif>
		<cfreturn getEngineBeanFactory().getBean(getEngineBeanName()) />
	</cffunction>

	<cffunction name="setupEngineBeanFactory" hint="Setup the bean factory for Validat" access="public" output="false" returntype="Any">
		<cfset var local = StructNew() />
		<cfscript>
			// Set up the engine bean factory
			if (Len(getEngineConfigXmlPath())) {
				// Initialize a ColdSpring factory 
				local.csFactory = createObject("component", "coldspring.beans.DefaultXmlBeanFactory").init();
				local.csFactory.loadBeansFromXmlFile(expandPath(getEngineConfigXmlPath()), true);
				// Link the parent factory to the engine factory?
				if (getFactoryHierarchyEnabled()) {
					local.csFactory.setParent(getBeanFactory());
				}
				setEngineBeanFactory(local.csFactory);
			} else {
				// Use the parent bean factory as the engine bean factory
				setEngineBeanFactory(getBeanFactory());
			}
		</cfscript>
	</cffunction>

	<cffunction name="getValidat" hint="Return a configured instance of the validation engine" access="public" output="false" returntype="Any">
		<cfargument name="rulesConfigXmlPath" type="string" required="true" hint="The path to the rules configuration xml file" />
		<cfset var local = StructNew() />

		<!--- Get an engine instance, configure it with rules, then return it --->
		<cfset local.validat = getEngineInstance() />
		<cfset local.validat.parseConfigXML(arguments.rulesConfigXmlPath) />
		<cfreturn local.validat />
	</cffunction>
</cfcomponent>