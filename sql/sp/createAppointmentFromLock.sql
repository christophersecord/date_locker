drop procedure if exists dl_createAppointmentFromLock;

DELIMITER //

/** createAppointmentFromLock
 * @hint 
 */
create procedure dl_createAppointmentFromLock(
  in lockTokenStr char(46),
  in clientID int,
  out appointmentID int
)
begin

  declare sTime datetime;
  declare eTime datetime;
  declare pLockID int;

  call dl_getLockedAppointment(lockTokenStr,sTime,eTime,pLockID);

  if !isNull(pLockID) then

    insert dl_appointment (clientID, startTime, endTime)
    values (clientID,sTime,eTime);

    set appointmentID = last_insert_id();

    delete from dl_appointmentLock where lockID = pLockID;
 
  end if;

end //

