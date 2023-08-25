/** stored procedure for date_locker project
 * @author christophersecord
 * @date 20130304
 * @language SQL
 * @platform mySQL
 */
drop procedure if exists dl_appointmentGet;

DELIMITER //

/** appointmentGet
 * returns a query containing all information about an appointment
 */
create procedure dl_appointmentGet (
  in pAppointmentID int
)
begin

  select *
  from dl_appointment
  where appointmentID = pAppointmentID;
 
end //

