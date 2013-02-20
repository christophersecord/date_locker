/** stored procedure for dana_lupo project
 * @author christophersecord
 * @date 20130319
 * @language SQL
 * @platform mySQL
 */
drop procedure if exists dl_businessHoursList;

DELIMITER //

/** businessHoursList
 * for a selected day, returns the current business hours
 */
create procedure dl_businessHoursList (in selectedDayOfWeek int)
begin

  select startAvailability, endAvailability
  from dl_businessHours
  where dayOfWeek = selectedDayOfWeek
  order by startAvailability;

end //
