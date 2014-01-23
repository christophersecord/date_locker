<cfcomponent>

	<cffunction name="lockAppointment" returntype="string"
		hint="writes a lock row for an appointment time if the appointment is available. returns a lockTokenStr which is a string used to identify the lock"
	>
		<cfargument name="startTime" type="datetime"/>
		<cfargument name="endTime" type="datetime"/>
		
		<cfset var lockTokenString = ""/>
		<cfstoredproc procedure="dl_lockAppointment" datasource="danalupo">
			<cfprocparam value="#startTime#" cfsqltype="cf_sql_timestamp"/>
			<cfprocparam value="#endTime#" cfsqltype="cf_sql_timestamp"/>
			<cfprocparam type="out" variable="lockTokenString" cfsqltype="cf_sql_varchar"/>
		</cfstoredproc>
		
		<cfreturn lockTokenString/>
	</cffunction>

	<cffunction name="lockedAppointmentGet" returntype="struct"
		hint="gets info on a single locked appointment, identified by the lock Token String. returns a struct containing exists,StartTime,EndTime"
	>
		<cfargument name="lockTokentString" type="string"/>

		<cfset var tmpResult = structNew()/>
		<cfset tmpResult.startTime = ""/>
		<cfset tmpResult.endTime = ""/>
		
		<cfstoredproc procedure="dl_lockAppointmentGet" datasource="danalupo">
			<cfprocparam value="#lockTokenString#" cfsqltype="cf_sql_varchar"/>

			<cfprocparam type="out" variable="#tmpResult.startTime#" cfsqltype="cf_sql_timestamp"/>
			<cfprocparam type="out" variable="#tmpResult.endTime#" cfsqltype="cf_sql_timestamp"/>
		</cfstoredproc>

		<cfset tmpResult.exists = isDate(tmpResult.startTime)/>

		<cfreturn tmpResult/>
	</cffunction>

	<cffunction name="lockedAppointmentDelete" returntype="void"
		hint="deletes a single locked appointment, identified by a lock Token String"
	>
		<cfargument name="lockTokentString" type="string"/>
	
		<cfstoredproc procedure="dl_lockedAppointmentDelete" datasource="danalupo">
			<cfprocparam value="#lockTokenString#" cfsqltype="cf_sql_varchar"/>
		</cfstoredproc>
	</cffunction>

	<cffunction name="lockCleanup" returntype="void"
		hint="deletes timed-out locks. Truncates the table (for performance reasons) if no valid locks remain"
	>
		<cfstoredproc procedure="dl_lockCleanup" datasource="danalupo"/>
	</cffunction>

</cfcomponent>