/** base tables for dana_lupo project
 * @author christophersecord
 * @date 20130203
 * @language SQL
 * @platform mySQL
 */
drop table if exists dl_appointmentLock;
drop table if exists dl_appointment;
drop table if exists dl_client;
drop table if exists dl_availability;

/** availability
 * @hint stores the hours on each day of the week when appointments can be made
*/
create table dl_availability (
  dayOfWeek int not null,
  startAvailability datetime not null,
  endAvailability datetime not null
);

/** client
 * @hint one row per client that has scheduled an appointment.
 * clientID=1 corresponds to a "lock" - an appointment that is in the process of being booked
 * clientID=2 corresponds to a blocked-out time (meaning, a block where you don't want to allow people to book times)
 */
create table dl_client (
  clientID int not null auto_increment primary key,
  emailAddress varchar(250) not null,
  passwd char(32) not null
);
insert dl_client (emailAddress,passwd)
values ('locked','');
insert dl_client (emailAddress,passwd)
values ('blocked','');

/** appointment
 * @hint one row per scheduled appointment or blocked time
 */
create table dl_appointment (
	appointmentID int not null auto_increment primary key,
	clientID int not null,

  startTime datetime not null,
  endTime datetime not null,

  bookedOn timestamp not null default now(),

  googleCalendarGUID varchar(250) null,
  memo varchar(250) null,

  foreign key(clientID) references dl_client(clientID)
);

/** appointmentLock
 * @hint temporarily locks a block of time so that a user can log in or pay or whatever
 */
create table dl_appointmentLock (
	lockID int not null auto_increment primary key,
	lockToken char(36) not null,

  startTime datetime not null,
  endTime datetime not null,

  bookedOn timestamp not null default now()
);