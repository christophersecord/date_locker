/** stored procedure for date_locker project
 * @author christophersecord
 * @date 20130319
 * @language SQL
 * @platform mySQL
 */
drop procedure if exists dl_availabilityGetBlocks;

DELIMITER //

/** availabilityGetBlocks
 * for a selected day, returns all available 30-minute time blocks
 */
create procedure dl_availabilityGetBlocks (in selectedDay date)
begin

  declare pStart datetime default selectedDay;

  declare aptInterval int;
  select min(minutes)
  into aptInterval
  from dl_appointmentDuration

  create temporary table availability (
    startTime datetime not null
  );

  -- loop through all time blocks in the current day
  while day(selectedDay) = day(pStart) do
 
    -- is the smallest possible appointment available at this time?
    if dl_isAvailable(pStart,date_add(pStart, interval aptInterval minute))
    then 

      insert availability
      values (pStart);
 
    end if;

    -- loops in 30 minute steps
    set pStart = date_add(pStart, interval aptInterval minute);

  end while;

  select startTime from availability;

  drop table availability;

end //
