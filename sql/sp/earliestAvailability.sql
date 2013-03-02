/** function for dana_lupo project
 * @author christophersecord
 * @date 20130319
 * @language SQL
 * @platform mySQL
 */
drop function if exists dl_earliestAvailability;

DELIMITER //

/** earliestAvailability
 * returns the earliest possible appointment availability based on business rules on dl_config
 * Eample: if the current time is 6:00 PM, no one should be allowed to book an appointment before noon the next day
 */
create function dl_earliestAvailability ()
returns datetime
begin

  declare availabilityDate datetime
  default str_to_date(concat(year(now()),'-',month(now()),'-',day(now())),'%Y-%m-%d');

  -- get config constants
  declare min_advance int;
  declare advance_stt datetime;

  select intVal
  into min_advance
  from dl_config
  where varName='apt_min_advance';

  select dateVal
  into advance_stt
  from dl_config
  where varName = 'apt_advance_stt';

  -- add the selected number of days
  set availabilityDate = date_add(availabilityDate,interval min_advance day);

  -- if the time is after the selected time, then add an additional day
  if hour(now()) >= hour(advance_stt) then
    set availabilityDate = date_add(availabilityDate,interval 1 day);
  end if;

  return availabilityDate;

end //