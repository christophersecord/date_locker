/** stored procedure for date_locker project
 * @author christophersecord
 * @date 20130319
 * @language SQL
 * @platform mySQL
 */
drop procedure if exists dl_appointmentCreateFromLock;

DELIMITER //

/** appointmentCreateFromLock
 * creates and appointment from an appointment lock, then deletes the lock 
 */
create procedure dl_appointmentCreateFromLock (
  in pLockTokenStr char(46),
  in pClientID int,
  out appointmentID int
)
begin

  declare sTime datetime;
  declare eTime datetime;
  declare pLockID int;

  call dl_lockedAppointmentGet(pLockTokenStr,sTime,eTime,pLockID);

  if (not isNull(pLockID)) then

    insert dl_appointment (clientID, startTime, endTime)
    values (pClientID,sTime,eTime);

    set appointmentID = last_insert_id();

    delete from dl_appointmentLock where lockID = pLockID;
 
  end if;

end //

