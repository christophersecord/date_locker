/** base tables for dana_lupo project
 * @author christophersecord
 * @date 20130203
 * @language SQL
 * @platform mySQL
 */
drop table if exists dl_login;
drop table if exists dl_appointmentLock;
drop table if exists dl_appointment;
drop table if exists dl_businessHours;
drop table if exists dl_appointmentDuration;
drop table if exists dl_client;
drop table if exists dl_config;

/** config
 * @hint application config values
 */
create table dl_config (
  varName char(15) not null primary key,
  intVal int null,
  charVal varchar(50) null,
  dateVal datetime null
);
insert dl_config (varName,intVal) values ('apt_start_times',30);
insert dl_config (varName,intVal) values ('apt_min_advance',24);
insert dl_config (varName,intVal) values ('apt_lock_time',720);

/** client
 * @hint one row per client that has scheduled an appointment.
 * clientID=1 corresponds to a blocked-out time (meaning, a block where you don't want to allow people to book times)
 */
create table dl_client (
  clientID int not null auto_increment primary key,
  emailAddress varchar(250) not null,
  passwd char(32) not null
);
insert dl_client (emailAddress,passwd) values ('blocked','');

/** appointmentDuration
 * @hint allowable durations, in minutes, of an appointment
 */
create table dl_appointmentDuration (
  minutes tinyint not null primary key
);
insert dl_appointmentDuration values (30);
insert dl_appointmentDuration values (60);
insert dl_appointmentDuration values (90);

/** businessHours
 * @hint the hours on each day of the week when appointments can be made
 */
create table dl_businessHours (
  dayOfWeek int not null,
  startAvailability datetime not null,
  endAvailability datetime not null
);
-- create availability blocks for M and F from 10:00-12:00 and 13:00-17:00
insert dl_businessHours (dayOfWeek,startAvailability,endAvailability)
values (2,'1900-01-01 10:00','1900-01-01 12:00');
insert dl_businessHours (dayOfWeek,startAvailability,endAvailability)
values (2,'1900-01-01 13:00','1900-01-01 17:00');
insert dl_businessHours (dayOfWeek,startAvailability,endAvailability)
values (6,'1900-01-01 10:00','1900-01-01 12:00');
insert dl_businessHours (dayOfWeek,startAvailability,endAvailability)
values (6,'1900-01-01 13:00','1900-01-01 17:00');

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

/** login
 * @hint stores login information
 */
create table dl_login (
  loginID int not null auto_increment primary key,
  loginToken char(36) not null,

  clientID int not null,

  loginTime datetime not null,
  logoutTime datetime not null,

  foreign key(clientID) references dl_client(clientID)
);