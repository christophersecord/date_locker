/** stored procedure for dana_lupo project
 * @author christophersecord
 * @date 20130319
 * @language SQL
 * @platform mySQL
 */
drop procedure if exists dl_lockAppointment;

DELIMITER //

/** lockAppointment
 * writes a lock row for an appointment time if the appointment is available.
 * returns a lockTokenStr which is a string used to identify the lock
 */
create procedure dl_lockAppointment (
	in aStartTime datetime,
	in aEndTime datetime, 
	
	out lockTokenStr varchar(46)
)
begin

  declare lockID int;
  declare token char(36) default uuid();

  if dl_isAvailable(aStartTime,aEndTime) then
    insert dl_appointmentLock (lockToken,startTime,endTime)
    values (token,aStartTime,aEndTime);

    set lockID = last_insert_id();

  end if;

  set lockTokenStr = concat(lockID,',',token);


end //