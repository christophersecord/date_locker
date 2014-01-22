<!--- **
 * tests the functionality clientExists
--->
<cfcomponent extends="_SP">

<!--- **
 * passes if the client doesn't yet exist
 * note: the ancestor class _SP's setup method makes sure the client table is empty on starting
--->
<cffunction name="noExistingClient">
	<cfset var clientEmail = "validEmail@domain.com"/>

	<!--- client doesn't yet exist --->
	<cfquery name="q" datasource="danalupo">
		select dl_clientExists('#clientEmail#') as clientExists
	</cfquery>
	<cfset assertFalse(q.clientExists,"client doesn't yet exist")/>

</cffunction>

<!--- **
 * passes if a client (created by this test) exists
--->
<cffunction name="existingClient">
	<cfset var clientEmail = "validEmail@domain.com"/>

	<!--- client doesn't yet exist --->
	<cfquery name="q" datasource="danalupo">
		select dl_clientExists('#clientEmail#') as clientExists
	</cfquery>
	<cfset assertFalse(q.clientExists,"client doesn't yet exist")/>

	<!--- create client --->
	<cfstoredproc procedure="dl_clientCreate" datasource="danalupo">
		<cfprocparam value="#clientEmail#" cfsqltype="cf_sql_varchar"/>
		<cfprocparam value="passwd" cfsqltype="cf_sql_varchar"/>
		<cfprocparam type="out" variable="clientID" cfsqltype="cf_sql_integer"/>
	</cfstoredproc>

	<!--- client now exists --->
	<cfquery name="q" datasource="danalupo">
		select dl_clientExists('#clientEmail#') as clientExists
	</cfquery>
	<cfset assertTrue(q.clientExists,"client now exists")/>

</cffunction>

</cfcomponent>