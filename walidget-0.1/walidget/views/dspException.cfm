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

This file was derived from /modelgluesamples/Widget/transfer/views/dspException.cfm.

MODIFIED VERSION INFORMATION:

$Id: dspException.cfm 7 2009-03-13 06:00:31Z boomfish $

ORIGINAL VERSION INFORMATION:

This file was part of Model-Glue Model-Glue: ColdFusion (2.0.304).

The version number in parenthesis is in the format versionNumber.subversion.revisionNumber.
--->
<h3>Oops!</h3>

<cfset exception = viewstate.getValue("exception") />

<cfoutput>
<table>
	<tr>
		<td valign="top"><b>Message</b></td>
		<td valign="top">#exception.message#</td>
	</tr>
	<cfif request.viewDefaults.getConfigSetting("showExceptionDetail")>
	<tr>
		<td valign="top"><b>Detail</b></td>
		<td valign="top">#exception.detail#</td>
	</tr>
	<tr>
		<td valign="top"><b>Extended Info</b></td>
		<td valign="top">#exception.ExtendedInfo#</td>
	</tr>
	<tr>
		<td valign="top"><b>Tag Context</b></td>
		<td valign="top">
			<cfset tagCtxArr = exception.TagContext />
			<cfloop index="i" from="1" to="#ArrayLen(tagCtxArr)#">
				<cfset tagCtx = tagCtxArr[i] />
				#tagCtx['template']# (#tagCtx['line']#)<br>
			</cfloop>
		</td>
	</tr>
	</cfif>
</table>
</cfoutput>