drop procedure if exists dl_getBusinessHours;

DELIMITER //

/** getBusinessHours
 * @hint for a selected day, returns the current business hours
 */
create procedure dl_getBusinessHours(in selectedDayOfWeek int)
begin

  select startAvailability, endAvailability
  from dl_businessHours
  where dayOfWeek = selectedDayOfWeek
  order by startAvailability;

end //
