drop procedure if exists dl_getAvailableDaysOfWeek;

DELIMITER //

/** getAvailableDaysOfWeek
 * @hint returns the days of the week (as int, Sunday=1) when appointments are possible
 */
create procedure dl_getAvailableDaysOfWeek()
begin

  select distinct dayOfWeek
  from dl_availability
  order by dayOfWeek;

end //