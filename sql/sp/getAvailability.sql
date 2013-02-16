drop procedure if exists dl_getAvailability;

DELIMITER //

/** getAvailability
 * @hint for a selected day, returns all available 30-minute time blocks
 */
create procedure dl_getAvailability(in selectedDay date)
begin

  declare pStart datetime default selectedDay;
  declare pEnd datetime;

  create temporary table availability (
    startTime datetime not null
  );

  -- loop through all time blocks in the current day
  while day(selectedDay) = day(pStart) do
 
    -- is the smallest possible appointment available at this time?
    -- TODO: get smallest appoint from dl_appointmentDuration
    set pEnd = date_add(pStart, interval 30 minute);
    if dl_isAvailable(pStart,pEnd)
    then 

      insert availability
      values (pStart);
 
    end if;

    -- TODO: this loops in 30 minute steps. It should be configurable
    set pStart = date_add(pStart, interval 30 minute);

  end while;

  select startTime from availability;

  drop table availability;

end //
