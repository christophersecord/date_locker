<cfcomponent>

	<cffunction name="clientGet" returntype="query"
		hint="gets all info about a client given their clientID"
	>
		<cfargument name="clientID" type="numeric"/>
		
		<cfset var q = 0/>
		<cfstoredproc procedure="dl_clientGet" datasource="dl">
			<cfprocparam value="#clientID#" cfsqltype="cf_sql_integer"/>
			<cfprocresult name="q"/>
		</cfstoredproc>
		
		<cfreturn q/>
	</cffunction>

	<cffunction name="clientExists" returntype="boolean"
		hint="returns true if a client, identified by a username, exists"
	>
		<cfargument name="emailAddress" type="string"/>

		<cfset var q = 0/>

		<cfquery name="q" datasource="dl">
			select dl_clientExists(
				<cfqueryparam value="#emailAddress#" cfsqltype="cf_sql_varchar"/>
			) as clientExists
		</cfquery>

		<cfreturn q.clientExists/>
	</cffunction>

 	<cffunction name="clientCreate" returntype="numeric"
		hint="creates a client"
	>
		<cfargument name="emailAddress" type="string"/>
		<cfargument name="passwd" type="string"/>
		
		<cfset var clientID = 0/>
		<cfstoredproc procedure="dl_clientCreate" datasource="dl">
			<cfprocparam value="#emailAddress#" cfsqltype="cf_sql_varchar"/>
			<cfprocparam value="#passwd#" cfsqltype="cf_sql_varchar"/>
			<cfprocparam type="out" variable="clientID" cfsqltype="cf_sql_integer"/>
		</cfstoredproc>
		
		<cfreturn clientID/>
	</cffunction>

	<!--- TODO: make an SP for this --->
 	<cffunction name="clientUpdate" returntype="numeric"
		hint="updates a client's info"
	>
		<cfargument name="clientID" type="numeric"/>
	</cffunction>

</cfcomponent>