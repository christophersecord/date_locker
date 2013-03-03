/** stored procedure for dana_lupo project
 * @author christophersecord
 * @date 20130319
 * @language SQL
 * @platform mySQL
 */
drop procedure if exists dl_lockedAppointmentGet;

DELIMITER //

/** lockedAppointmentGet
 * gets info on a single locked appointment, identified by the lockToken
 */
create procedure dl_lockedAppointmentGet (
  in lockTokenStr varchar(46), 
  out pStart datetime, 
  out pEnd datetime,
  out pLockID int
)
begin

  select lockID, startTime, endTime
  into pLockID, pStart, pEnd
  from dl_appointmentLock
  where lockID = dl_listFirst(lockTokenStr)
    and lockToken = dl_listRest(lockTokenStr);

end //