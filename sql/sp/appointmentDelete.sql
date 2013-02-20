/** stored procedure for dana_lupo project
 * @author christophersecord
 * @date 20130319
 * @language SQL
 * @platform mySQL
 */
drop procedure if exists dl_appointmentDelete;

DELIMITER //

/** appointmentDelete
 * deletes an appointment
 */
create procedure dl_appointmentDelete (
  in pAppointmentID int,
)
begin

  delete
  from dl_appointment
  where appointmentID = pAppointmentID 
 
end //

