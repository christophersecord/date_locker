drop procedure if exists dl_createAppointmentAvailabilityBlock;

DELIMITER //

/** createAppointmentAvailabilityBlock
 * @hint creates a block of time inside business hours in which appointments can't be made
 * or a block of time outside business hours in which appoints can be made
 */
create procedure dl_createAppointmentBlock(
  sTime datetime,
  eTime datetime,
  pAppointmentsAllowed bit,

  out blockID int
)
begin

  insert dl_appointmentAvailabilityBlock (startTime, endTime, appointmentsAllowed)
  values (sTime,eTime,pAppointmentsAllowed);

  set blockID = last_insert_id();

end //

