<cfcomponent>

	<cffunction name="appointmentAvailabilityBlockCreate" returntype="numeric"
		hint="creates a block of time inside business hours in which appointments can't be made or a block of time outside business hours in which appointments can be made. Returns the ID of the block just created."
	>
		<cfargument name="startTime" type="datetime"/>
		<cfargument name="endTime" type="datetime"/>
		<cfargument name="appointmentsAllowed" type="boolean" default="false"/>
		
		<cfset var blockID = 0/>
		<cfstoredproc procedure="dl_appointmentAvailabilityBlockCreate" datasource="dl">
			<cfprocparam value="#startTime#" cfsqltype="cf_sql_timestamp"/>
			<cfprocparam value="#endTime#" cfsqltype="cf_sql_timestamp"/>
			<cfprocparam value="#appointmentsAllowed#" cfsqltype="cf_sql_bit"/>
			<cfprocparam type="out" variable="blockID" cfsqltype="cf_sql_integer"/>
		</cfstoredproc>
		
		<cfreturn blockID/>
	</cffunction>
	
	<cffunction name="appointmentAvailabilityBlockDelete" returntype="void"
		hint="deletes an appointment availability block"
	>
		<cfargument name="blockID" type="numeric"/>
		
		<cfstoredproc procedure="dl_appointmentAvailabilityBlockDelete" datasource="dl">
			<cfprocparam value="#blockID#" cfsqltype="cf_sql_integer"/>
		</cfstoredproc>
		
	</cffunction>

	<cffunction name="appointmentAvailabilityBlockList" returntype="query"
		hint="lists all appointment availability blocks for a given date"
	>
		<cfargument name="blockDate" type="date"/>
		
		<cfset var q = 0/>
		<cfstoredproc procedure="dl_appointmentAvailabilityBlockList" datasource="dl">
			<cfprocparam value="#blockDate#" cfsqltype="cf_sql_date"/>
			<cfprocresult name="q"/>
		</cfstoredproc>
		
		<cfreturn q/>
	</cffunction>

	<cffunction name="appointmentList" returntype="query"
		hint="returns all appointments for a specific date"
	>
		<cfargument name="appointmentDate" type="date"/>
		
		<cfset var q = 0/>
		<cfstoredproc procedure="dl_appointmentList" datasource="dl">
			<cfprocparam value="#appointmentDate#" cfsqltype="cf_sql_date"/>
			<cfprocresult name="q"/>
		</cfstoredproc>
		
		<cfreturn q/>
	</cffunction>

	<cffunction name="availabilityGetBlocks" returntype="query"
		hint="for a selected day, returns all available 30-minute time blocks"
	>
		<cfargument name="selectedDay" type="datetime"/>
		
		<cfset var q = 0/>
		<cfstoredproc procedure="dl_availabilityGetBlocks" datasource="dl">
			<cfprocparam value="#selectedDay#" cfsqltype="cf_sql_date"/>
			<cfprocresult name="q"/>
		</cfstoredproc>
		
		<cfreturn q/>
	</cffunction>

	<cffunction name="businessHoursList" returntype="query"
		hint="for a selected day, returns the current business hours"
	>
		<cfargument name="dayOfWeek" type="numeric"/>
		
		<cfset var q = 0/>
		<cfstoredproc procedure="dl_businessHoursList" datasource="dl">
			<cfprocparam value="#dayOfWeek#" cfsqltype="cf_sql_integer"/>
			<cfprocresult name="q"/>
		</cfstoredproc>

		<cfreturn q/>
	</cffunction>

	<cffunction name="businessHoursListDaysOfWeek" returntype="query"
		hint="returns the days of the week (as int, Sunday=1) when appointments are possible"
	>
		
		<cfset var q = 0/>
		<cfstoredproc procedure="dl_businessHoursListDaysOfWeek" datasource="dl">
			<cfprocresult name="q"/>
		</cfstoredproc>

		<cfreturn q/>
	</cffunction>

	<cffunction name="businessHoursSet" returntype="void">
		<cfargument name="dayOfWeek" type="numeric"/>
		<cfargument name="openBlocks" type="string"/>
		
		<cfstoredproc procedure="dl_businessHoursSet" datasource="dl">
			<cfprocparam value="#dayOfWeek#" cfsqltype="cf_sql_integer"/>
			<cfprocparam value="#openBlocks#" cfsqltype="cf_sql_varchar"/>
		</cfstoredproc>
	</cffunction>

	<cffunction name="isAvailable" returntype="boolean">
		<cfargument name="startTime" type="datetime"/>
		<cfargument name="endTime" type="datetime"/>
		
		<cfset var q = 0/>

		<cfquery name="q" datasource="dl">
			select dl_isAvailable(
				<cfqueryparam value="#startTime#" cfsqltype="cf_sql_timestamp"/>,
				<cfqueryparam value="#endTime#" cfsqltype="cf_sql_timestamp"/>
			) as availability
		</cfquery>

		<cfreturn q.availability/>
	</cffunction>

	<cffunction name="isAvailableReason" returntype="string">
		<cfargument name="startTime" type="datetime"/>
		<cfargument name="endTime" type="datetime"/>
		
		<cfset var q = 0/>

		<cfquery name="q" datasource="dl">
			select dl_isAvailableReason(
				<cfqueryparam value="#startTime#" cfsqltype="cf_sql_timestamp"/>,
				<cfqueryparam value="#endTime#" cfsqltype="cf_sql_timestamp"/>
			) as availability
		</cfquery>

		<cfreturn q.availability/>
	</cffunction>
		
	
</cfcomponent>