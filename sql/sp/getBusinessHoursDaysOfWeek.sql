drop procedure if exists dl_getBusinessHoursDaysOfWeek;

DELIMITER //

/** getAvailableDaysOfWeek
 * @hint returns the days of the week (as int, Sunday=1) when appointments are possible
 */
create procedure dl_getBusinessHoursDaysOfWeek()
begin

  select distinct dayOfWeek
  from dl_businesshours
  order by dayOfWeek;

end //