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

$Id: dspTemplate.cfm 13 2009-03-24 05:15:27Z boomfish $

ORIGINAL VERSION INFORMATION:

This file was part of Model-Glue Model-Glue: ColdFusion (2.0.304).

The version number in parenthesis is in the format versionNumber.subversion.revisionNumber.
--->

<!--- Use the applicationTitle in the viewstate if available, else use the one in the view defaults --->
<cfset applicationTitle = viewstate.getValue("applicationTitle",request.viewDefaults.getConfigSetting("applicationTitle")) />

<cfoutput>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<title>#applicationTitle#</title>
	<link rel="stylesheet" type="text/css" href="#request.resourceUrls.css#/stylesheet.css" media="screen">
	<link rel="stylesheet" type="text/css" href="#request.resourceUrls.css#/widget.css" media="screen">
</head>

<body>
<div>
	<div id="banner">#applicationTitle#</div>
	<div>
		<div>
			#viewcollection.getView("topNav")#
			<table width="100%">
			<tr>
				<td valign="top">
					#viewcollection.getView("body")#
				</td>
				<td width="200" valign="top">
					#viewcollection.getView("bottomNav")#
				</td>
			</tr>
			</table>
		</div>
	</div>
	<div id="footer" style="clear:both">
				<p><a href="http://walidget.riaforge.org/">Walidget</a> is &copy; 2009 Dennis Clark.  It is Free Open Source Software, distributed under the Apache License, Version 2.0.</p>
	</div>
</div>
</body>
</html>
</cfoutput>	