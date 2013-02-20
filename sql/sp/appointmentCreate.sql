/** stored procedure for dana_lupo project
 * @author christophersecord
 * @date 20130319
 * @language SQL
 * @platform mySQL
 */
drop procedure if exists dl_appointmentCreate;

DELIMITER //

/** appointmentCreate
 * unconditionally creates an appointment
 */
create procedure dl_appointmentCreate (
  in pClientID int,
  in pStartTime datetime,
  in pEndTime datetime,

  out appointmentID int
)
begin

  insert dl_appointment (clientID, startTime, endTime)
  values (pClientID,pStartTime,pEndTime);

  set appointmentID = last_insert_id();
 
end //

