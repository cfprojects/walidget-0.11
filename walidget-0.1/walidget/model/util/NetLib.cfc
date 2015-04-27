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

$Id: NetLib.cfc 11 2009-03-21 16:05:52Z boomfish $
--->
<cfcomponent hint="I provide network library functions" output="false">

	<cffunction name="IPv4Address2Integer" access="public" output="false" returntype="numeric"
				hint="Convert a dotted-decimal IPv4 address string to a signed 32-bit integer">
		<cfargument name="ipv4Address" required="true" type="string" />

		<!--- This function is a rewrite of the IPAddress2IPDottedDecimal UDF by Jonathan Pickard (j_pickard@hotmail.com) --->
		<cfscript>
			var netInteger = 0;
			var i = 1;
			var octet = 0;
			
			for (i=1; i lte 4; i=i+1) {
				octet = ListGetAt(arguments.ipDottedDecimal, i, ".");
				netInteger = BitMaskSet(netInteger, octet, 8*(4-i), 8);
			}
			return netInteger;
		</cfscript>
	</cffunction>

	<cffunction name="Integer2IPv4Address" access="public" output="false" returntype="string"
				hint="Convert a signed 32-bit integer to a dotted-decimal IPv4 address string">
		<cfargument name="netInteger" required="true" type="numeric" />
		
		<!--- This function is a rewrite of the IPDottedDecimal2IPAddress UDF by Jonathan Pickard (j_pickard@hotmail.com) --->
		<cfscript>
			var ipv4Address = "";
			var i = 1;
			var octet = 0;
			
			for (i=1; i lte 4; i=i+1) {
				octet = BitMaskRead(arguments.netInteger, 8*(4-i), 8);
				ipv4Address = ListAppend(ipv4Address, octet, ".");
			}
			return ipv4Address;
		</cfscript>
	</cffunction>

</cfcomponent>