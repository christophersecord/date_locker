drop function if exists dl_isAvailable;

DELIMITER //

/** isAvailable
 * @hint returns true if the proposed time block is available as an appointment
 */
create function dl_isAvailable(aStartTime datetime, aEndTime datetime)
returns bit
begin

  declare pStart datetime
  default str_to_date(concat('1900-01-01 ',hour(aStartTime),':',minute(aStartTime)),'%Y-%m-%d %H:%i');

  -- note, the end time is set to one minute before the input end time so that midnight isn't seen as the next day
  declare pEnd datetime 
  default str_to_date(concat('1900-01-01 ',hour(aEndTime),':',minute(aEndTime)-1),'%Y-%m-%d %H:%i');

  -- end time must be greater than start time
  if aEndTime <= aStartTime then
    return 0;
  end if;

  -- TODO: startTime must start on an hour or half-hour boundry
  -- TODO: appointment length must be an approved time

  if exists (
    -- does the proposed appointment fit entirely within a designated availability block
    select * from dl_availability
    where
      startAvailability <= pStart
      and endAvailability >= pEnd
      and dayOfWeek = dayOfWeek(aStartTime)
  ) and not exists (
    -- is there no other appointment that conflicts with it
    select * from dl_appointment
    where
      aStartTime between startTime and endTime
      or aEndTime between startTime and endTime

  ) and not exists (
    -- this timeblock is not locked by another user
    select * from dl_appointmentLock
    where
      aStartTime between startTime and endTime
      or aEndTime between startTime and endTime
  ) then

    return 1;

  end if;

  return 0;

end //