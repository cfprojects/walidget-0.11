<?xml version="1.0" encoding="UTF-8"?>
<!--
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

This file was derived from /ModelGlue/unity/xsl/list.xsl.
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text" indent="no"  />

	<xsl:template match="/">    

&lt;cfset outputDateFormat = request.viewDefaults.getConfigSetting("outputDateFormat") /&gt;
&lt;cfset outputTimeFormat = request.viewDefaults.getConfigSetting("outputTimeFormat") /&gt;
&lt;cfset midnightTimeFormatted = TimeFormat(CreateTime(0,0,0),outputTimeFormat) /&gt;

&lt;cfset viewEvent = viewstate.getValue("myself") &amp; viewstate.getValue("xe.view") /&gt;
&lt;cfset editEvent = viewstate.getValue("myself") &amp; viewstate.getValue("xe.edit") /&gt;
&lt;cfset deleteEvent = viewstate.getValue("myself") &amp; viewstate.getValue("xe.delete") /&gt;
&lt;cfset <xsl:value-of select="object/alias"/>Query = viewstate.getValue("<xsl:value-of select="object/alias"/>Query") /&gt;

    
&lt;cfoutput&gt;
&lt;div id="breadcrumb"&gt;<xsl:value-of select="object/label"/>s / &lt;a href="#editEvent#"&gt;Add New <xsl:value-of select="object/label"/>&lt;/a&gt;&lt;/div&gt;
&lt;/cfoutput&gt;
&lt;br&gt;
&lt;table class="list"&gt;
&lt;thead&gt;
&lt;tr&gt;
  &lt;cfset displayedColumns = 1 /&gt;
  <xsl:for-each select="object/properties/property">
    <xsl:if test="primarykey = 'false' and relationship='false' and length &lt; 65535">
		  &lt;cfset displayedColumns = displayedColumns + 1 /&gt;
	 		&lt;th&gt;<xsl:value-of select="label"/>&lt;/th&gt;
    </xsl:if>
  </xsl:for-each>
	&lt;th&gt;&amp;nbsp;&lt;/th&gt;
&lt;/tr&gt;
&lt;/thead&gt;
&lt;tbody&gt;
&lt;cfif not <xsl:value-of select="object/alias"/>Query.recordcount&gt;
	&lt;tr&gt;
		&lt;cfoutput&gt;&lt;td colspan="#displayedColumns#"&gt;&lt;em&gt;No Records&lt;/em&gt;&lt;/td&gt;&lt;/cfoutput&gt;
	&lt;/tr&gt;
&lt;/cfif&gt;
&lt;cfoutput query="<xsl:value-of select="object/alias"/>Query"&gt;
	&lt;cfset keyString = "<xsl:for-each select="object/properties/property"><xsl:if test="primarykey = 'true'">&amp;amp;<xsl:value-of select="alias"/>=#urlEncodedFormat(<xsl:value-of select="/object/alias"/>Query.<xsl:value-of select="alias"/>)#</xsl:if></xsl:for-each>" />
	&lt;tr &lt;cfif <xsl:value-of select="object/alias"/>Query.currentRow mod 2 eq 0&gt;class="even"&lt;/cfif&gt;&gt;
    <xsl:for-each select="object/properties/property">
		<xsl:if test="primarykey = 'false' and relationship='false' and length &lt; 65535">
				<xsl:if test="cfdatatype = 'date'">
					&lt;cfset dateFormatted = DateFormat(<xsl:value-of select="alias"/>,outputDateFormat) /&gt;
					&lt;cfif TimeFormat(<xsl:value-of select="alias"/>,outputTimeFormat) neq midnightTimeFormatted&gt;
					  &lt;cfset dateFormatted = dateFormatted &amp; " " &amp; TimeFormat(<xsl:value-of select="alias"/>,outputTimeFormat) /&gt;
					&lt;/cfif&gt;
			 		&lt;td&gt;&lt;a href="#viewEvent##keystring#"&gt;#dateFormatted#&lt;/a&gt;&lt;/td&gt;
				</xsl:if>
				<xsl:if test="cfdatatype = 'boolean'">
			 		&lt;td&gt;&lt;a href="#viewEvent##keystring#"&gt;#YesNoFormat(<xsl:value-of select="alias"/>)#&lt;/a&gt;&lt;/td&gt;
				</xsl:if>
				<xsl:if test="cfdatatype != 'date' and cfdatatype != 'boolean'">
			 		&lt;td&gt;&lt;a href="#viewEvent##keystring#"&gt;#htmlEditFormat(<xsl:value-of select="alias"/>)#&lt;/a&gt;&lt;/td&gt;
				</xsl:if>
		</xsl:if>
    </xsl:for-each>
		&lt;td&gt;
			&lt;a href="#editEvent##keystring#"&gt;Edit&lt;/a&gt;	
			&lt;a href="##" onclick="if (confirm('Are you sure you want to delete this <xsl:value-of select="/object/label"/>?')) { document.location.replace('#deleteEvent##keystring#') }; return false"&gt;Delete&lt;/a&gt;
		&lt;/td&gt;
	&lt;/tr&gt;
&lt;/cfoutput&gt;
&lt;/tbody&gt;
&lt;/table&gt;
                 
	</xsl:template>
</xsl:stylesheet>