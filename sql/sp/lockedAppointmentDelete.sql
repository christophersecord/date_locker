/** stored procedure for dana_lupo project
 * @author christophersecord
 * @date 20130306
 * @language SQL
 * @platform mySQL
 */
drop procedure if exists dl_lockedAppointmentDelete;

DELIMITER //

/** lockedAppointmentDelete
 * deletes a single locked appointment, identified by a lock Token String
 */
create procedure dl_lockedAppointmentDelete (
  in lockTokenStr varchar(46)
)
begin

  delete
  from dl_appointmentLock
  where lockID = dl_listFirst(lockTokenStr)
    and lockToken = dl_listRest(lockTokenStr);

end //