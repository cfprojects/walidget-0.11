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

This file was derived from /ModelGlue/unity/xsl/view.xsl.
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text" indent="no"  />

	<xsl:template match="/">    

&lt;cfset outputDateFormat = request.viewDefaults.getConfigSetting("outputDateFormat") /&gt;
&lt;cfset outputTimeFormat = request.viewDefaults.getConfigSetting("outputTimeFormat") /&gt;
&lt;cfset midnightTimeFormatted = TimeFormat(CreateTime(0,0,0),outputTimeFormat) /&gt;

&lt;cfset listEvent = viewstate.getValue("myself") &amp; viewstate.getValue("xe.list")  /&gt;
&lt;cfset commitEvent = viewstate.getValue("myself") &amp; viewstate.getValue("xe.commit") &amp; "&amp;amp;<xsl:value-of select="object/alias"/>Id=" &amp; urlEncodedFormat(viewstate.getValue("<xsl:value-of select="object/alias"/>Id")) /&gt;
&lt;cfset <xsl:value-of select="object/alias"/>Record = viewstate.getValue("<xsl:value-of select="object/alias"/>Record") /&gt;
&lt;cfset validation = viewstate.getValue("<xsl:value-of select="object/alias"/>Validation", structNew()) /&gt;

&lt;cfoutput&gt;
&lt;div id="breadcrumb"&gt;&lt;a href="#listEvent#"&gt;<xsl:value-of select="object/label"/>s&lt;/a&gt; / View <xsl:value-of select="object/label"/>&lt;/div&gt;
&lt;/cfoutput&gt;
&lt;br&gt;
  
&lt;form class="edit" method="get" action="##"&gt;
    
&lt;fieldset&gt;
    
<xsl:for-each select="object/properties/property">
  <xsl:if test="(primarykey = 'false' or relationship = 'true')">
    <xsl:if test="relationship = 'false'">
        &lt;div class="formfield"&gt;
	      <xsl:if test="nullable = 'true' or nullable = '1'">
	        &lt;cfif structKeyExists(<xsl:value-of select="/object/alias"/>Record, "get<xsl:value-of select="alias"/>IsNull")
	            and <xsl:value-of select="/object/alias"/>Record.get<xsl:value-of select="alias"/>IsNull()&gt;
	          &lt;cfset propertyValue = "&lt;em&gt;Null&lt;/em&gt;" /&gt;
	        &lt;cfelse&gt;
	      </xsl:if>
		  <xsl:if test="cfdatatype = 'date'">
	          &lt;cfset propertyValue = <xsl:value-of select="/object/alias"/>Record.get<xsl:value-of select="alias"/>() /&gt;
	          &lt;cfif TimeFormat(propertyValue,outputTimeFormat) eq midnightTimeFormatted&gt;
	            &lt;cfset propertyValue = DateFormat(propertyValue,outputDateFormat) /&gt;
	          &lt;cfelse&gt;
	            &lt;cfset propertyValue = DateFormat(propertyValue,outputDateFormat) &amp; " " &amp; TimeFormat(propertyValue,outputTimeFormat) /&gt;
	          &lt;/cfif&gt;
		  </xsl:if>
		  <xsl:if test="cfdatatype = 'boolean'">
	        &lt;cfset propertyValue = YesNoFormat(<xsl:value-of select="/object/alias"/>Record.get<xsl:value-of select="alias"/>()) /&gt;
		  </xsl:if>
		  <xsl:if test="cfdatatype != 'date' and cfdatatype != 'boolean'">
	        &lt;cfset propertyValue = HtmlEditFormat(<xsl:value-of select="/object/alias"/>Record.get<xsl:value-of select="alias"/>()) /&gt;
		  </xsl:if>
	      <xsl:if test="nullable = 'true' or nullable = '1'">
	        &lt;/cfif&gt;
	      </xsl:if>
          &lt;cfoutput&gt;
	        &lt;label for="<xsl:value-of select="alias"/>"&gt;&lt;b&gt;<xsl:value-of select="label"/>:&lt;/b&gt;&lt;/label&gt;
	        &lt;span class="input"&gt;#propertyValue#&lt;/span&gt;
	        &lt;/cfoutput&gt;
        &lt;/div&gt;
    </xsl:if>
    <xsl:if test="relationship = 'true'">
      <xsl:if test="pluralrelationship = 'false'">
        &lt;div class="formfield"&gt;
          &lt;cfoutput&gt;
	        &lt;label for="<xsl:value-of select="alias"/>"&gt;&lt;b&gt;<xsl:value-of select="label"/>:&lt;/b&gt;
	        &lt;/label&gt;
				&lt;cfset targetObjectIsNull = true&gt;
				&lt;cfif structKeyExists(<xsl:value-of select="/object/alias"/>Record, "get<xsl:value-of select="alias"/>")&gt;
					&lt;cfif <xsl:value-of select="/object/alias"/>Record.has<xsl:value-of select="alias"/>()&gt;
						&lt;cfset targetObject = <xsl:value-of select="/object/alias"/>Record.get<xsl:value-of select="alias"/>() /&gt;
						&lt;cfset targetObjectIsNull = false /&gt;
					&lt;/cfif&gt;
				&lt;cfelseif structKeyExists(<xsl:value-of select="/object/alias"/>Record, "getParent<xsl:value-of select="alias"/>")&gt;
					&lt;cfset targetObject = <xsl:value-of select="/object/alias"/>Record.getParent<xsl:value-of select="alias"/>() /&gt;
					&lt;cfset targetObjectIsNull = false /&gt;
				&lt;/cfif&gt;
				
	        &lt;div&gt;
	        	&lt;cfif targetObjectIsNull&gt;
	        		&lt;em&gt;Null&lt;/em&gt;
	        	&lt;cfelse&gt;
	       			#HtmlEditFormat(targetObject.get<xsl:value-of select="sourcecolumn"/>())#
	       		&lt;/cfif&gt; 
	        &lt;/div&gt;
	        &lt;/cfoutput&gt;
        &lt;/div&gt;
      </xsl:if>
      <xsl:if test="pluralrelationship = 'true'">
        &lt;div class="formfield"&gt;
        	&lt;label&gt;&lt;b&gt;<xsl:value-of select="label"/>(s):&lt;/b&gt;&lt;/label&gt;

					&lt;!--- This XSL supports both Reactor and Transfer ---&gt;
					&lt;cfif structKeyExists(<xsl:value-of select="/object/alias"/>Record, "get<xsl:value-of select="alias"/>Struct")&gt;
						&lt;cfset selected = <xsl:value-of select="/object/alias"/>Record.get<xsl:value-of select="alias"/>Struct() /&gt;
					&lt;cfelseif structKeyExists(<xsl:value-of select="/object/alias"/>Record, "get<xsl:value-of select="alias"/>Array")&gt;
						&lt;cfset selected = <xsl:value-of select="/object/alias"/>Record.get<xsl:value-of select="alias"/>Array() /&gt;
					&lt;cfelse&gt;
						&lt;cfset selected = <xsl:value-of select="/object/alias"/>Record.get<xsl:value-of select="alias"/>Iterator().getQuery() /&gt;
					&lt;/cfif&gt;

					&lt;cfif isQuery(selected)&gt;
						&lt;div class="formfieldinputstack"&gt;
						&lt;ul&gt;
						&lt;cfif not selected.RowCount&gt;
						  &lt;li&gt;&lt;em&gt;None&lt;/em&gt;&lt;/li&gt;
						&lt;cfelse&gt;
						  &lt;cfoutput query="selected"&gt;
							&lt;li&gt;#HtmlEditFormat(selected.<xsl:value-of select="sourcecolumn"/>)#&lt;/li&gt;
						  &lt;/cfoutput&gt;
						&lt;/cfif&gt;
						&lt;/ul&gt;
						&lt;/div&gt;
					&lt;cfelseif isStruct(selected)&gt;
						&lt;cfoutput&gt;
						&lt;div class="formfieldinputstack"&gt;
						&lt;ul&gt;
						&lt;cfif StructIsEmpty(selected)&gt;
						  &lt;li&gt;&lt;em&gt;None&lt;/em&gt;&lt;/li&gt;
						&lt;cfelse&gt;
						  &lt;cfloop collection="#selected#" item="i"&gt;
							&lt;li&gt;#HtmlEditFormat(selected[i].get<xsl:value-of select="sourcecolumn"/>())#&lt;/li&gt;
						  &lt;/cfloop&gt;
						&lt;/cfif&gt;
						&lt;/ul&gt;
						&lt;/div&gt;
						&lt;/cfoutput&gt;
					&lt;cfelseif isArray(selected)&gt;
						&lt;cfoutput&gt;
						&lt;div class="formfieldinputstack"&gt;
						&lt;ul&gt;
						&lt;cfif ArrayIsEmpty(selected)&gt;
						  &lt;li&gt;&lt;em&gt;None&lt;/em&gt;&lt;/li&gt;
						&lt;cfelse&gt;
						  &lt;cfloop from="1" to="#arrayLen(selected)#" index="i"&gt;
							&lt;li&gt;#HtmlEditFormat(selected[i].get<xsl:value-of select="sourcecolumn"/>())#&lt;/li&gt;
						  &lt;/cfloop&gt;
						&lt;/cfif&gt;
						&lt;/ul&gt;
						&lt;/div&gt;
						&lt;/cfoutput&gt;
					&lt;/cfif&gt;

        &lt;/div&gt;
          
      </xsl:if>
    </xsl:if>
  </xsl:if>
</xsl:for-each>
&lt;/fieldset&gt;
&lt;/div&gt;
&lt;/form&gt;
    
	</xsl:template>
</xsl:stylesheet>