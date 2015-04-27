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

This file was derived from /ModelGlue/unity/orm/transfer/TransferAdapter.cfc.

MODIFIED VERSION INFORMATION:

$Id: TransferAdapter.cfc 7 2009-03-13 06:00:31Z boomfish $

ORIGINAL VERSION INFORMATION:

This file was part of Model-Glue Model-Glue: ColdFusion (2.0.304).

The version number in parenthesis is in the format versionNumber.subversion.revisionNumber.
--->
<cfcomponent extends="ModelGlue.unity.orm.transfer.TransferAdapter" hint="I am just like the Model-Glue Transfer ORM adapter, but with a couple less bugs.">

<cffunction name="determineSource" returntype="void" output="false" access="private">
	<cfargument name="field" type="struct" required="true" />
	<cfargument name="relationship" type="struct" required="true" />
	
	<cfset var rmd = getTransferMetadata(arguments.relationship.name) />
	<cfset var dict = getTransferDictionary(arguments.relationship.name) />
	<cfset var fields = rmd.getfields() />
	<cfset var i = "" />

	<cfif not arrayLen(fields)>
		<cfthrow type="TransferAdapter.determineSource.noFields" message="The source table (#arguments.relationship.name#) has no columns." />
	</cfif>
	
	<cfset arguments.field.sourceObject = arguments.relationship.name />
	<cfset arguments.field.sourceColumn = fields[1].alias />
	
	<cfloop from="1" to="#arrayLen(fields)#" index="i">
		<cfif fields[i].primaryKey>
			<cfset arguments.field.sourceKey = fields[i].alias />
		</cfif>
	</cfloop>

	<cfloop from="1" to="#arrayLen(fields)#" index="i">
		<cfif fields[i].cfDataType eq "string"
					and right(fields[i].name, 2) neq "id"
					and fields[i].length lt 65535>
			<cfset arguments.field.sourceColumn = fields[i].alias />
			<cfbreak />
		</cfif>
	</cfloop>

	<cfset arguments.field.label = dict.getValue("#arguments.relationship.name#.#arguments.field.sourceColumn#.label") />
	<cfset arguments.field.comment = dict.getValue("#arguments.relationship.name#.#arguments.field.sourceColumn#.comment") />
	<cfset arguments.field.label = determineLabel(arguments.field.alias) />
</cffunction>


<cffunction name="assemble" returntype="void" output="false" access="public">
	<cfargument name="event" type="ModelGlue.unity.eventrequest.EventContext" required="true" />
	<cfargument name="target" type="any" required="true" />

	<cfset var record = arguments.target />
	<cfset var table = arguments.event.getArgument("object") />
	<cfset var objectName = listLast(table, ".") />
	<cfset var metadata = getObjectMetadata(table) />
	<cfset var property = "" />
	<cfset var targetObject = "" />
	<cfset var criteria = "" />
	<cfset var newValue = "" />
	<cfset var sourceObject = "" />
	<cfset var currentChildren = "" />
	<cfset var selectedChildId = "" />
	<cfset var selectedChildIds = "" />
	<cfset var currentChild = "" />
	<cfset var currentChildId = "" />
	<cfset var currentChildIds = "" />
	<cfset var testedChildId = "" />
	<cfset var childRecord = "" />
	<cfset var i = "" />
	<cfset var j = "" />
	<cfset var tmp = "" />
	<cfset var deletionQueue = arrayNew(1) />
	<cfset var usePropertiesList = arguments.event.argumentExists("properties") />
	<cfset var propertiesList = arguments.event.getArgument("properties", "") />
	
	<!--- Update all direct properties --->
	
	<!--- Update simple properties --->
	<cfloop collection="#metadata.properties#" item="i">
		<cfset property = metadata.properties[i] />

		<cfif not property.relationship and not property.primaryKey>
			<cfset sourceObject = property.Alias />
			
			<cfif not usePropertiesList or ListFind(propertiesList,sourceObject)>
				<cfset newValue = arguments.event.getValue(sourceObject) />
				
				<cfif property.nullable and not len(newValue)>
					<cfinvoke component="#record#" method="set#sourceObject#Null" />
				<cfelse>
					<cftry>
						<cfinvoke component="#record#" method="set#sourceObject#">
							<cfinvokeargument name="#sourceObject#" value="#newValue#" />
						</cfinvoke>
						<cfcatch>
							<!--- Silently ignore invalid values for now --->
						</cfcatch>
					</cftry>
				</cfif>
			</cfif>
		</cfif>
	</cfloop>
		
	<!--- Update manyToOne properties --->
	<cfloop collection="#metadata.properties#" item="i">
		<cfset property = metadata.properties[i] />

		<cfif property.relationship and not property.pluralRelationship>
			<cfset criteria = structNew() />
			<cfset sourceObject = listLast(property.sourceObject, ".") />

			<cfset newValue = arguments.event.getValue(sourceObject) />
			
			<cfif len(newValue)>
				<cfset criteria[property.sourceKey] = arguments.event.getValue(sourceObject) />
				
				<cfset targetObject = read(property.sourceObject, criteria) />
				
				<!--- If it's a natural relationship --->
				<cfif structKeyExists(record, "set#sourceObject#")>
					<cfinvoke component="#record#" method="set#sourceObject#">
						<cfinvokeargument name="transfer" value="#targetObject#" />
					</cfinvoke>
				<!--- If it's the artificially added reflexive relationship --->
				<cfelseif structKeyExists(record, "setParent#sourceObject#")>
					<cfinvoke component="#record#" method="setParent#sourceObject#">
						<cfinvokeargument name="transfer" value="#targetObject#" />
					</cfinvoke>
				<cfelse>
					<cfthrow type="modelglue.unity.orm.TransferAdapter.NoManyToOneSetter" message="TransferAdapter can't find a valid method to set the #sourceObject# property on #table#!" />
				</cfif>
			<cfelse>
				<!--- If it's a natural relationship --->
				<cfif structKeyExists(record, "remove#sourceObject#")>
					<cfinvoke component="#record#" method="remove#sourceObject#" />
				<!--- If it's the artificially added reflexive relationship --->
				<cfelseif structKeyExists(record, "removeParent#sourceObject#")>
					<cfinvoke component="#record#" method="removeParent#sourceObject#" />
				<cfelse>
					<cfthrow type="modelglue.unity.orm.TransferAdapter.NoManyToOneSetter" message="TransferAdapter can't find a valid method to remove the #sourceObject# property on #table#!" />
				</cfif>
			</cfif>
		</cfif>
	</cfloop>

	<!--- Manage plural relationship properties --->
	<cfloop collection="#metadata.properties#" item="i">
		<!--- Only do this if the property is a plural relationship and the form contains the needed value --->
		<cfif metadata.properties[i].relationship eq true 
					and metadata.properties[i].pluralrelationship
					and arguments.event.valueExists("#metadata.properties[i].alias#|#metadata.properties[i].sourceKey#")>

			<cfset property = metadata.properties[i] />
			<cfset sourceObject = listLast(property.sourceObject, ".") />
			
			<!--- Get a collection of current child records --->
			<cfif structKeyExists(record, "get#metadata.properties[i].alias#Struct")>
				<cfinvoke component="#record#" method="get#metadata.properties[i].alias#Struct" returnvariable="currentChildren" />
				<cfset currentChildIds = structKeyList(currentChildren) />
			<cfelseif structKeyExists(record, "get#metadata.properties[i].alias#Array")>
				<cfinvoke component="#record#" method="get#metadata.properties[i].alias#Array" returnvariable="currentChildren" />
				<cfloop from="1" to="#arrayLen(currentChildren)#" index="j">
					<cfinvoke component="#currentChildren[j]#" method="get#metadata.properties[i].sourceKey#" returnvariable="currentChildId" />
					<cfset currentChildIds = listAppend(currentChildIds, currentChildId) />
				</cfloop>
			<cfelse>
				<cfthrow type="ModelGlue.unity.orm.TransferAdapter.UnknownCollectionType" message="The Transfer Adapter can't find a collection method (get#metadata.properties[i].alias#Struct or get#metadata.properties[i].alias#Array) for the get#metadata.properties[i].alias# property of #table#." />
			</cfif>
			
			<!--- What children are selected in the form? --->
			<cfset selectedChildIds = arguments.event.getValue("#metadata.properties[i].alias#|#metadata.properties[i].sourceKey#") />
			
			<!--- Loop over the currentChildren deleting any unselected children --->
			<cfloop list="#currentChildIds#" index="currentChildId">
				<cfif not listFindNoCase(selectedChildIds, currentChildId)>
					<cfif isStruct(currentChildren)>
						<cfif not property.linkingRelationship>
							<cfinvoke component="#currentChildren[currentChildId]#" method="removeParent#objectName#" />
							<cfset getTransfer().save(currentChildren[currentChildId], false) />
						<cfelse>
							<cfinvoke component="#record#" method="remove#listLast(property.Alias, ".")#">
								<cfinvokeargument name="object" value="#currentChildren[currentChildId]#" />
							</cfinvoke>
						</cfif>
					<cfelseif isArray(currentChildren)>
						<cfloop from="1" to="#arrayLen(currentChildren)#" index="j">
							<cfinvoke component="#currentChildren[j]#" method="get#metadata.properties[i].sourceKey#" returnvariable="testedChildId" />
							<cfif testedChildId eq currentChildId>
								<cfif not property.linkingRelationship>
									<cfinvoke component="#currentChildren[j]#" method="removeParent#objectName#" />
									<cfset getTransfer().save(currentChildren[j], false) />
								<cfelse>
									<cfinvoke component="#record#" method="remove#listLast(property.sourceObject, ".")#">
										<cfinvokeargument name="object" value="#currentChildren[j]#" />
									</cfinvoke>
								</cfif>
								<cfbreak />
							</cfif>
						</cfloop>
					</cfif>
				</cfif>
			</cfloop>

			<!--- Add any selected children to the currentChildren, adding any new children --->
			<cfloop list="#selectedChildIds#" index="selectedChildId">
				<cfif not listFindNoCase(currentChildIds, selectedChildId)>
					<cfset currentChild = getTransfer().readByProperty(property.sourceObject, metadata.properties[i].sourceKey, selectedChildId) />

					<cfif not property.linkingRelationship>
						<cfinvoke component="#currentChild#" method="setParent#objectName#">
							<cfinvokeargument name="transfer" value="#record#" />
						</cfinvoke>
						<cfset getTransfer().save(currentChild, false) />
					<cfelse>
						<cfinvoke component="#record#" method="add#property.Alias#">
							<cfinvokeargument name="object" value="#currentChild#" />
						</cfinvoke>
					</cfif>
				</cfif>
			</cfloop>
		</cfif>
	</cfloop>	

</cffunction>

</cfcomponent>