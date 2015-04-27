<!---
COPYRIGHT INFORMATION:

Copyright 2007 Joe Rinehart
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

MODIFIED FILE NOTICE:

Modifier(s): Dennis Clark

This file is a Derivative Work made under and subject to the terms of the above License.

The original source was downloaded from the following location:

	http://www.model-glue.com/downloads/modelglue_2.0.304.zip

This file was derived from /modelgluesamples/Widget/transfer/views/dspTemplate.cfm.

MODIFIED VERSION INFORMATION:

$Id: dspTopNav.cfm 7 2009-03-13 06:00:31Z boomfish $

ORIGINAL VERSION INFORMATION:

This file was part of Model-Glue Model-Glue: ColdFusion (2.0.304).

The version number in parenthesis is in the format versionNumber.subversion.revisionNumber.
--->

<cfscript>
	// Exit events
	widgetListExitEvent         = viewstate.getValue("myself") & viewstate.getValue("xe.widgetList");
	widgetTypeListExitEvent     = viewstate.getValue("myself") & viewstate.getValue("xe.widgetTypeList");
	widgetCategoryListExitEvent = viewstate.getValue("myself") & viewstate.getValue("xe.widgetCategoryList");
	widgetColourListExitEvent   = viewstate.getValue("myself") & viewstate.getValue("xe.widgetColourList");
</cfscript>

<cfoutput>
	[<a href="#widgetListExitEvent#">Manage Widgets</a>]
	[<a href="#widgetTypeListExitEvent#">Manage Widget Types</a>]
	[<a href="#widgetCategoryListExitEvent#">Manage Widget Categories</a>]
	[<a href="#widgetColourListExitEvent#">Manage Widget Colours</a>]
</cfoutput>