<cfcomponent>

	<cffunction name="appointmentCreate" returntype="numeric"
		hint="unconditionally creates an appointment"
	>
		<cfargument name="clientID" type="numeric"/>
		<cfargument name="startTime" type="datetime"/>
		<cfargument name="endTime" type="datetime"/>
		
		<cfset var appointmentID = 0/>
		<cfstoredproc procedure="dl_appointmentCreate" datasource="danalupo">
			<cfprocparam value="#clientID#" cfsqltype="cf_sql_integer"/>
			<cfprocparam value="#startTime#" cfsqltype="cf_sql_timestamp"/>
			<cfprocparam value="#endTime#" cfsqltype="cf_sql_timestamp"/>
			<cfprocparam type="out" variable="appointmentID" cfsqltype="cf_sql_integer"/>
		</cfstoredproc>
		
		<cfreturn appointmentID/>
	</cffunction>

	<cffunction name="appointmentCreateFromLock" returntype="numeric"
		hint="creates and appointment from an appointment lock, then deletes the lock"
	>
		<cfargument name="lockTokenString" type="string"/>
		<cfargument name="clientID" type="numeric"/>
		
		<cfset var appointmentID = 0/>
		<cfstoredproc procedure="dl_appointmentCreateFromLock" datasource="danalupo">
			<cfprocparam value="#lockTokenString#" cfsqltype="cf_sql_char"/>
			<cfprocparam value="#clientID#" cfsqltype="cf_sql_integer"/>
			<cfprocparam type="out" variable="appointmentID" cfsqltype="cf_sql_integer"/>
		</cfstoredproc>
		
		<cfreturn appointmentID/>
	</cffunction>

	<cffunction name="appointmentDelete" returntype="void"
		hint="deletes an appointment"
	>
		<cfargument name="appointmentID" type="numeric"/>
		
		<cfstoredproc procedure="dl_appointmentDelete" datasource="danalupo">
			<cfprocparam value="#appointmentID#" cfsqltype="cf_sql_integer"/>
		</cfstoredproc>
		
	</cffunction>


</cfcomponent>