 Brief Docs for SPs
=================
appointmentAvailabilityBlockCreate
-------------------------

procedure
* in sTime datetime
* in eTime datetime
* in pAppointmentsAllowed bit
* out blockID int

creates a block of time inside business hours in which appointments can't be made or a block of time outside business hours in which appoints can be made
appointmentAvailabilityBlockDelete
-------------------------

procedure
* in pBlockID int

deletes an appointment availability block
appointmentAvailabilityBlockList
-------------------------

procedure
* in pDate date

lists all appointment availability blocks for a given date
appointmentCreate
-------------------------

procedure
* in pClientID int
* in pStartTime datetime
* in pEndTime datetime
* out appointmentID int

unconditionally creates an appointment
appointmentCreateFromLock
-------------------------

procedure
* in pLockTokenStr char(46)
* in pClientID int
* out appointmentID int

creates and appointment from an appointment lock, then deletes the lock
appointmentDelete
-------------------------

procedure
* in pAppointmentID int

deletes an appointment
appointmentList
-------------------------

procedure
* in pDate date

returns all appointments for a specific date
availabilityGetBlocks
-------------------------

procedure
* in selectedDay date

for a selected day, returns all available 30-minute time blocks
businessHoursList
-------------------------

procedure
* in selectedDayOfWeek int

for a selected day, returns the current business hours
businessHoursListDaysOfWeek
-------------------------

procedure

returns the days of the week (as int, Sunday=1) when appointments are possible
businessHoursSet
-------------------------

procedure
* in selectedDayOfWeek int
* in openBlocks varchar(250)

sets blocks of time when appointments are possible on a given day of week. openBlocks is a string of comma-delimited times in the format, HH:MM
earliestAvailability
-------------------------

function - returns: datetime

returns the earliest possible appointment availability based on business rules on dl_config Eample: if the current time is 6:00 PM, no one should be allowed to book an appointment before noon the next day
isAvailable
-------------------------

function - returns: bit
* aStartTime datetime
* aEndTime datetime

returns true if the proposed time block is available as an appointment and is a valid appointment
isAvailableReason
-------------------------

function - returns: varchar(100)
* aStartTime datetime
* aEndTime datetime

if an appointment time is not available, returns a string indicating why
listLen
-------------------------

function - returns: int
* list varchar(250)

counts the number of items in a comma-delimited list
lockAppointment
-------------------------

procedure
* in aStartTime datetime
* in aEndTime datetime
* out lockTokenStr varchar(46)

writes a lock row for an appointment time if the appointment is available. returns a lockTokenStr which is a string used to identify the lock
lockCleanup
-------------------------

procedure

deletes timed-out locks. Truncates the table (for performance reasons) if no valid locks remain
lockedAppointmentGet
-------------------------

procedure
* in lockTokenStr varchar(46)
* out pStart datetime
* out pEnd datetime
* out pLockID int

gets info on a single locked appointment, identified by the lockToken
