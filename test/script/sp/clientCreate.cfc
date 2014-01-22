<!--- **
 * tests the functionality of SP: clientCreate
--->
<cfcomponent extends="_SP">

<!--- **
 * new client is written to the database
--->
<cffunction name="newClient">
	<cfset var clientID = 0/>
	<cfset var clientEmail = "validEmail@domain.com"/>

	<!--- client doesn't yet exist --->
	<cfquery name="q" datasource="danalupo">
		select * from dl_client
		where emailAddress = <cfqueryparam value="#clientEmail#" cfsqltype="cf_sql_varchar"/>
	</cfquery>
	<cfset assert(q.recordCount eq 0,"client doesn't yet exist")/>

	<!--- create client --->
	<cfstoredproc procedure="dl_clientCreate" datasource="danalupo">
		<cfprocparam value="#clientEmail#" cfsqltype="cf_sql_varchar"/>
		<cfprocparam value="passwd" cfsqltype="cf_sql_varchar"/>
		<cfprocparam type="out" variable="clientID" cfsqltype="cf_sql_integer"/>
	</cfstoredproc>
	
	<cfset assertTrue(isNumeric(clientID),"clientID is numeric")/>

	<!--- client exists --->
	<cfquery name="q" datasource="danalupo">
		select * from dl_client
		where emailAddress = <cfqueryparam value="#clientEmail#" cfsqltype="cf_sql_varchar"/>
	</cfquery>
	<cfset assert(q.recordCount eq 1,"client exists")/>
	<cfset assert(q.clientID eq clientID,"clientID matches what was returned by the SP")/>


</cffunction>

<!--- **
 * an existing client isn't overridden
--->
<cffunction name="existingClient">
	<cfset var clientID = 0/>
	<cfset var clientEmail = "validEmail@domain.com"/>
	<cfset var encryptedPasswd = ""/>

	<!--- create the client --->
	<cfstoredproc procedure="dl_clientCreate" datasource="danalupo">
		<cfprocparam value="#clientEmail#" cfsqltype="cf_sql_varchar"/>
		<cfprocparam value="passwd" cfsqltype="cf_sql_varchar"/>
		<cfprocparam type="out" variable="clientID" cfsqltype="cf_sql_integer"/>
	</cfstoredproc>

	<cfset assertTrue(isNumeric(clientID),"clientID is valid")/>

	<!--- lookup the encrypted password --->
	<cfquery name="q" datasource="danalupo">
		select * from dl_client
		where clientID = <cfqueryparam value="#clientID#" cfsqltype="cf_sql_integer"/>
	</cfquery>
	<cfset encryptedPasswd = q.passwd/>

	<!--- creating a duplicate client should fail --->
	<cfstoredproc procedure="dl_clientCreate" datasource="danalupo">
		<cfprocparam value="#clientEmail#" cfsqltype="cf_sql_varchar"/>
		<cfprocparam value="a different passwd" cfsqltype="cf_sql_varchar"/>
		<cfprocparam type="out" variable="clientID" cfsqltype="cf_sql_integer"/>
	</cfstoredproc>

	<cfset assertFalse(isNumeric(clientID),"clientID is not valid")/>

	<!--- check that the password wasn't overridden --->
	<cfquery name="q" datasource="danalupo">
		select * from dl_client
		where emailAddress = <cfqueryparam value="#clientEmail#" cfsqltype="cf_sql_varchar"/>
	</cfquery>
	<cfset assert(q.recordCount eq 1,"no duplicate record client was created")/>
	<cfset assert(q.passwd eq encryptedPasswd,"client wasn't overridden")/>
</cffunction>

</cfcomponent>