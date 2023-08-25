Brief Docs for SPs
=================

[appointmentAvailabilityBlockCreate](https://github.com/christophersecord/date_locker/blob/master/sql/sp/appointmentAvailabilityBlockCreate.sql)
-------------------------

procedure

* in sTime datetime
* in eTime datetime
* in pAppointmentsAllowed bit
* out blockID int

creates a block of time inside business hours in which appointments can't be made or a block of time outside business hours in which appointments can be made. Returns the ID of the block just created.

[appointmentAvailabilityBlockDelete](https://github.com/christophersecord/date_locker/blob/master/sql/sp/appointmentAvailabilityBlockDelete.sql)
-------------------------

procedure

* in pBlockID int

deletes an appointment availability block

[appointmentAvailabilityBlockList](https://github.com/christophersecord/date_locker/blob/master/sql/sp/appointmentAvailabilityBlockList.sql)
-------------------------

procedure

* in pDate date

lists all appointment availability blocks for a given date

[appointmentCreate](https://github.com/christophersecord/date_locker/blob/master/sql/sp/appointmentCreate.sql)
-------------------------

procedure

* in pClientID int
* in pStartTime datetime
* in pEndTime datetime
* out appointmentID int

unconditionally creates an appointment

[appointmentCreateFromLock](https://github.com/christophersecord/date_locker/blob/master/sql/sp/appointmentCreateFromLock.sql)
-------------------------

procedure

* in pLockTokenStr char(46)
* in pClientID int
* out appointmentID int

creates and appointment from an appointment lock, then deletes the lock

[appointmentDelete](https://github.com/christophersecord/date_locker/blob/master/sql/sp/appointmentDelete.sql)
-------------------------

procedure

* in pAppointmentID int

deletes an appointment

[appointmentGet](https://github.com/christophersecord/date_locker/blob/master/sql/sp/appointmentGet.sql)
-------------------------

procedure

* in pAppointmentID int

returns a query containing all information about an appointment

[appointmentList](https://github.com/christophersecord/date_locker/blob/master/sql/sp/appointmentList.sql)
-------------------------

procedure

* in pDate date

returns all appointments for a specific date

[availabilityGetBlocks](https://github.com/christophersecord/date_locker/blob/master/sql/sp/availabilityGetBlocks.sql)
-------------------------

procedure

* in selectedDay date

for a selected day, returns all available 30-minute time blocks

[businessHoursList](https://github.com/christophersecord/date_locker/blob/master/sql/sp/businessHoursList.sql)
-------------------------

procedure

* in selectedDayOfWeek int

for a selected day, returns the current business hours

[businessHoursListDaysOfWeek](https://github.com/christophersecord/date_locker/blob/master/sql/sp/businessHoursListDaysOfWeek.sql)
-------------------------

procedure


returns the days of the week (as int, Sunday=1) when appointments are possible

[businessHoursSet](https://github.com/christophersecord/date_locker/blob/master/sql/sp/businessHoursSet.sql)
-------------------------

procedure

* in selectedDayOfWeek int
* in openBlocks varchar(250)

sets blocks of time when appointments are possible on a given day of week. openBlocks is a string of comma-delimited times in the format, HH:MM

[clientAuthenticate](https://github.com/christophersecord/date_locker/blob/master/sql/sp/clientAuthenticate.sql)
-------------------------

procedure

* in pEmailAddress varchar(250)
* in plainTextPasswd varchar(250)
* out pClientID int

checks a username/password and returns the corresponding client if found

[clientCreate](https://github.com/christophersecord/date_locker/blob/master/sql/sp/clientCreate.sql)
-------------------------

procedure

* in pEmailAddress varchar(250)
* in plainTextPasswd varchar(250)
* out clientID int

creates a client

[clientExists](https://github.com/christophersecord/date_locker/blob/master/sql/sp/clientExists.sql)
-------------------------

function - returns: bit

* pEmailAddress varchar(250)

returns true if the client (identified by an email address) already exists

[clientGet](https://github.com/christophersecord/date_locker/blob/master/sql/sp/clientGet.sql)
-------------------------

procedure

* in pClientID int

gets all info about a client given their clientID

[clientLogin](https://github.com/christophersecord/date_locker/blob/master/sql/sp/clientLogin.sql)
-------------------------

procedure

* in pClientID varchar(250)
* out loginTokenString varchar(41)

returns a loginTokenString (a combination of loginID at token) to record that a client has logged in

[clientLogout](https://github.com/christophersecord/date_locker/blob/master/sql/sp/clientLogout.sql)
-------------------------

procedure

* in loginTokenString varchar(41)

logs out a client

[clientReturn](https://github.com/christophersecord/date_locker/blob/master/sql/sp/clientReturn.sql)
-------------------------

procedure

* in loginTokenString varchar(41)
* out pClientID int
* out pLoginTime datetime

when a client returns after an initial login, this procedure looks up their clientID and loginTime given their login token

[earliestAvailability](https://github.com/christophersecord/date_locker/blob/master/sql/sp/earliestAvailability.sql)
-------------------------

function - returns: datetime


returns the earliest possible appointment availability based on business rules on dl_config Eample: if the current time is 6:00 PM, no one should be allowed to book an appointment before noon the next day

[isAvailable](https://github.com/christophersecord/date_locker/blob/master/sql/sp/isAvailable.sql)
-------------------------

function - returns: bit

* aStartTime datetime
* aEndTime datetime

returns true if the proposed time block is available as an appointment and is a valid appointment

[isAvailableReason](https://github.com/christophersecord/date_locker/blob/master/sql/sp/isAvailableReason.sql)
-------------------------

function - returns: varchar(100)

* aStartTime datetime
* aEndTime datetime

if an appointment time is not available, returns a string indicating why

[listLen](https://github.com/christophersecord/date_locker/blob/master/sql/sp/listLen.sql)
-------------------------

function - returns: int

* list varchar(250)

counts the number of items in a comma-delimited list

[lockAppointment](https://github.com/christophersecord/date_locker/blob/master/sql/sp/lockAppointment.sql)
-------------------------

procedure

* in aStartTime datetime
* in aEndTime datetime
* out lockTokenStr varchar(46)

writes a lock row for an appointment time if the appointment is available. returns a lockTokenStr which is a string used to identify the lock

[lockCleanup](https://github.com/christophersecord/date_locker/blob/master/sql/sp/lockCleanup.sql)
-------------------------

procedure


deletes timed-out locks. Truncates the table (for performance reasons) if no valid locks remain

[lockedAppointmentDelete](https://github.com/christophersecord/date_locker/blob/master/sql/sp/lockedAppointmentDelete.sql)
-------------------------

procedure

* in lockTokenStr varchar(46)

deletes a single locked appointment, identified by a lock Token String

[lockedAppointmentGet](https://github.com/christophersecord/date_locker/blob/master/sql/sp/lockedAppointmentGet.sql)
-------------------------

procedure

* in lockTokenStr varchar(46)
* out pStart datetime
* out pEnd datetime

gets info on a single locked appointment, identified by the lock Token String