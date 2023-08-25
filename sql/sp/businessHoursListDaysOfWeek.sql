/** stored procedure for date_locker project
 * @author christophersecord
 * @date 20130319
 * @language SQL
 * @platform mySQL
 */
drop procedure if exists dl_businessHoursListDaysOfWeek;

DELIMITER //

/** businessHoursListDaysOfWeek
 * returns the days of the week (as int, Sunday=1) when appointments are possible
 */
create procedure dl_businessHoursListDaysOfWeek ()
begin

  select distinct dayOfWeek
  from dl_businesshours
  order by dayOfWeek;

end //