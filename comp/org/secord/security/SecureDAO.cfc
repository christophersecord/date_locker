<cfcomponent>

	<cffunction name="clientExists" returntype="boolean">
		<cfargument name="emailAddress" type="string"/>
		
		<cfset var q = 0/>

		<cfquery name="q" datasource="danalupo">
			select dl_clientExists(
				<cfqueryparam value="#emailAddress#" cfsqltype="cf_sql_varchar"/>
			) as clientExists
		</cfquery>

		<cfreturn q.clientExists/>
	</cffunction>

	<cffunction name="clientAuthenticate" returntype="string"
		hint="checks a username/password and returns the corresponding client if found"
	>
		<cfargument name="emailAddress" type="string"/>
		<cfargument name="passwd" type="string"/>
		
		<cfset var clientID = 0/>
		<cfstoredproc procedure="dl_clientAuthenticate" datasource="danalupo">
			<cfprocparam value="#emailAddress#" cfsqltype="cf_sql_varchar"/>
			<cfprocparam value="#passwd#" cfsqltype="cf_sql_varchar"/>
			<cfprocparam type="out" variable="clientID" cfsqltype="cf_sql_integer"/>
		</cfstoredproc>
		
		<!--- SP returns null if the client doesn't exist --->
		<cfif !isNumeric(clientID)><cfset clientID = 0/></cfif>
		
		<cfreturn clientID/>
	</cffunction>

	<cffunction name="clientLogin" returntype="string"
		hint="returns a loginTokenString (a combination of loginID at token) to record that a client has logged in"
	>
		<cfargument name="clientID" type="numeric"/>
		
		<cfset var loginTokenString = ""/>
		<cfstoredproc procedure="dl_clientLogin" datasource="danalupo">
			<cfprocparam value="#clientID#" cfsqltype="cf_sql_integer"/>
			<cfprocparam type="out" variable="loginTokenString" cfsqltype="cf_sql_varchar"/>
		</cfstoredproc>
		
		<cfreturn loginTokenString/>
	</cffunction>

	<cffunction name="clientReturn" returntype="numeric"
		hint="when a client returns after an initial login, this procedure looks up their clientID"
	>
		<cfargument name="loginTokenString" type="string"/>
		
		<cfset var clientID = 0/>
		<cfset var loginTime = ""/>
		<cfstoredproc procedure="dl_clientReturn" datasource="danalupo">
			<cfprocparam value="#loginTokenString#" cfsqltype="cf_sql_varchar"/>
			<cfprocparam type="out" variable="clientID" cfsqltype="cf_sql_integer"/>
			<cfprocparam type="out" variable="loginTime" cfsqltype="cf_sql_datetime"/>
		</cfstoredproc>
		
		<cfreturn clientID/>
	</cffunction>

	<cffunction name="clientLogout" returntype="void"
		hint="logs out a client"
	>
		<cfargument name="loginTokenString" type="string"/>
		
		<cfstoredproc procedure="dl_clientLogout" datasource="danalupo">
			<cfprocparam value="#loginTokenString#" cfsqltype="cf_sql_varchar"/>
		</cfstoredproc>
		
	</cffunction>


</cfcomponent>