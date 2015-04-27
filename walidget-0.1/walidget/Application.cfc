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

$Id: Application.cfc 12 2009-03-21 16:06:11Z boomfish $
--->
<cfcomponent extends="walidget.extensions.addons.coldspring.application.ColdSpringApplication" output="false">

	<!--- Application Setup --->
	<cfscript>
		// Application name, should be unique
		this.name = "walidget";
		// Should client vars be enabled?
		this.clientManagement = true;
		// Where should cflogin stuff persist
		this.loginStorage = "session";
		// Should we use sessions?
		this.sessionManagement = true;
		// How long do session vars persist?
		this.sessionTimeout= createTimeSpan(0,0,45,0);
		// Should we try to block 'bad' input from users?
		this.scriptProtect = "none";
		// Should we secure our JSON calls?
		this.secureJSON = false;
		// Should we use a prefix in front of JSON strings?
		this.secureJSONPrefix = "";
		
		// Define custom coldfusion mappings. Keys are mapping names, values are full paths
		this.mappings = StructNew();
		// Mapping for application root
		this.mappings["/walidget"] = GetDirectoryFromPath(GetCurrentTemplatePath());
		// Mapping for embedded Validat library
		this.mappings["/validat"] = this.mappings["/walidget"] & "/extensions/validat";
		// Define a list of custom tag paths
		this.customtagpaths = "";
		
		// Configuration structure for setting up this application's bean factory		
		this.beanFactoryConfig = StructNew();
		this.beanFactoryConfig.applicationVariableName = "beanFactory";
		this.beanFactoryConfig.definitionFilePath = ExpandPath("/walidget/config/ColdSpring.xml");
		this.beanFactoryConfig.constructNonLazyBeans = true;
		this.beanFactoryConfig.reloadKey = "init";
		this.beanFactoryConfig.reloadPassword = "true";
	</cfscript>

</cfcomponent>