/** base tables for date_locker project
 * @author christophersecord
 * @date 20130203
 * @language SQL
 * @platform mySQL
 */
drop table if exists dl_login;
drop table if exists dl_appointmentAvailabilityBlock;
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
/** add default config values
 */

-- apt_min_advance is the minimum advanced notice, in days, that must be given for an appointment.
-- 0 indicates that appointments can be made at 12:01 AM the following day (assuming business hours allow)
-- 1 indicates that, for example, if now() = 9AM monday, the test.dl_isAvailable
insert dl_config (varName,intVal) values ('apt_min_advance',1);

-- apt_advance_stt is the start time (the date part is ignored) from when apt_min_advance will be calculated.
-- it's sort of like an international dateline.
-- 18:00 means that at 17:59 a client can still book an appointment for the following day. But at 18:00 the
-- client would have to wait until the day after that to book.
insert dl_config (varName,dateVal) values ('apt_advance_stt','1900-01-01 18:00');

-- apt_start_times determines when appointments can start.
-- 30 means that appointments can start on the hour or half-hour
insert dl_config (varName,intVal) values ('apt_start_times',30);

-- apt_lock_time determines how long an appointment can be locked before the lock is deleted.
insert dl_config (varName,intVal) values ('apt_lock_time',720);

-- TODO: new clients have XX minutes added to their appointment on the calendar (still pay for the number they select)

/** client
 * @hint one row per client that has scheduled an appointment.
 */
create table dl_client (
  clientID int not null auto_increment primary key,
  emailAddress varchar(250) not null,
  passwd char(56) not null, -- stores SHA-2 hashes at 224 bits

  phoneNumber char(10) null,

  dateCreated timestamp not null default now(),

  unique(emailAddress)
);

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

/** appointmentAvailabilityBlock
 * @hint blocks off time when no appointments should be allowed, or when appointments are allowed outside business hours 
 */
create table dl_appointmentAvailabilityBlock (
  blockID int not null auto_increment primary key,
  appointmentsAllowed bit not null default 0,

  startTime datetime not null,
  endTime datetime not null,

  googleCalendarGUID varchar(250) null,
  memo varchar(250) null
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