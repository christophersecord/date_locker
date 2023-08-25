/** stored procedure for date_locker project
 * @author christophersecord
 * @date 20130319
 * @language SQL
 * @platform mySQL
 */
drop procedure if exists dl_appointmentAvailabilityBlockCreate;

DELIMITER //

/** appointmentAvailabilityBlockCreate
 * creates a block of time inside business hours in which appointments can't be made
 * or a block of time outside business hours in which appointments can be made.
 * Returns the ID of the block just created.
 */
create procedure dl_appointmentAvailabilityBlockCreate (
  in sTime datetime,
  in eTime datetime,
  in pAppointmentsAllowed bit,

  out blockID int
)
begin

  insert dl_appointmentAvailabilityBlock (startTime, endTime, appointmentsAllowed)
  values (sTime,eTime,pAppointmentsAllowed);

  set blockID = last_insert_id();

end //

