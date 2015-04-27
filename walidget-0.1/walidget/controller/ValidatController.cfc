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

$Id: ValidatController.cfc 7 2009-03-13 06:00:31Z boomfish $
--->
<cfcomponent extends="ModelGlue.unity.controller.Controller" hint="I perform input validation using the Validat library" output="false">
	
	<!--- Methods for getting beans / dependencies --->

	<cffunction name="getValidat" access="private" returnType="any" output="false" hint="Return the Validat library object">
		<cfreturn getModelGlue().getBean("validat") />
	</cffunction>

	<cffunction name="getNewErrorCollectionAdapter" access="private" returnType="any" output="false" hint="Return an new ValidatErrorCollectionAdapter object">
		<cfreturn getModelGlue().getBean("validatErrorCollectionAdapter") />
	</cffunction>

	<!--- Message listener methods --->
	
	<cffunction name="validateModelGlueCommit" access="public" returnType="void" output="false" hint="Validate a Model-Glue commit operation">
		<cfargument name="event" type="any" />
		<cfset var local = StructNew() />
		<cfscript>
			local.datasetName = arguments.event.getArgument("object");
			local.validationName = arguments.event.getArgument("validationName",local.datasetName & "Validation");
			local.dataCollection = arguments.event.getAllValues();
						
			local.validat = getValidat();
			
			// Do we have a dataset for the object being committed?
			if (local.validat.dataSetExists(local.datasetName)) {
				// Perform the validation and get the error messages
				local.validatErrors = local.validat.validate(local.datasetName, local.dataCollection);
				
				// If there are errors, put them into the view state and add a ValidationError result
				if (local.validatErrors.hasErrors()) {
					
					// Wrap the Validat errors in an adapter go get the Model-Glue errors					
					local.errorAdapter = getNewErrorCollectionAdapter();
					local.errorAdapter.setValidatErrorCollection(local.validatErrors);
					
					arguments.event.setValue(local.validationName,local.errorAdapter.getErrors());
					arguments.event.setValue(local.datasetName & "Committed", false);
					arguments.event.addResult("ValidationError");
				}
			}
		</cfscript>
	</cffunction>

</cfcomponent>