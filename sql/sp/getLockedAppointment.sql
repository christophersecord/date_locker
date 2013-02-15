drop procedure if exists dl_getLockedAppointment;

DELIMITER //

/** getLockedAppointment
 * @hint 
 */
create procedure dl_getLockedAppointment(in lockTokenStr varchar(46), out pStart datetime, out pEnd datetime)
begin

  declare delimLoc int default locate('-',lockTokenStr);
  declare tokenID int default substring(lockTokenStr,1,delimLoc-1);
  declare tokenGUID char(36) default substring(lockTokenStr,delimLoc+1,delimLoc+36);

  select startTime, endTime
  into pStart, pEnd
  from dl_appointmentLock
  where lockID = tokenID
    and lockToken = tokenGUID;


end //