drop function if exists dl_isAvailable;

DELIMITER //

/** isAvailable
 * @hint returns true if the proposed time block is available as an appointment and is a valid appointment
 * for testing purposes, returns 0 when an appointment is available and a number otherwise
 */
create function dl_isAvailable(aStartTime datetime, aEndTime datetime)
returns int
begin

  declare pStart datetime
  default str_to_date(concat('1900-01-01 ',hour(aStartTime),':',minute(aStartTime)),'%Y-%m-%d %H:%i');

  -- note, the end time is set to one minute before the input end time so that midnight isn't seen as the next day
  declare pEnd datetime 
  default date_add(str_to_date(concat('1900-01-01 ',hour(aEndTime),':',minute(aEndTime)),'%Y-%m-%d %H:%i'),interval -1 minute);

  declare pStartTimeOffset int;

  -- appointment must be far enough in advance
  declare duration int;
  select intVal
  into duration
  from dl_config
  where varName='apt_min_advance';

  if hour(timeDiff(aStartTime,now())) < duration then
    return 1;
  end if;

  -- end time must be greater than start time and be on the same day
  if (aEndTime <= aStartTime) || (day(aStartTime) != day(aEndTime)) then
    return 2;
  end if;

  -- startTime must start on an hour or half-hour boundry
  select minute(aStartTime)%intVal
  into pStartTimeOffset
  from dl_config where varName='apt_start_times';

  if pStartTimeOffset != 0 then
    return 3;
  end if;

  -- appointment length must be an approved duration
  if not exists (
    select *
    from dl_appointmentDuration
    where minutes = minute(timeDiff(aStartTime,aEndTime)) + hour(timeDiff(aStartTime,aEndTime))*60
  ) then
    return 4;
  end if;

  -- appointment must be on an allowed time block
/*
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
      (startTime < aStartTime and aStartTime < endTime) -- can't use "between" operator here because it matches <=
      or (startTime < aEndTime and aEndTime < endTime)

  ) and not exists (
    -- this timeblock is not locked by another user
    select * from dl_appointmentLock
    where
      (startTime < aStartTime and aStartTime < endTime) -- can't use "between" operator here either
      or (startTime < aEndTime and aEndTime < endTime)
  ) then

    return 1;

  end if;
*/ 
-- remove before flight
  if not exists (
    -- does the proposed appointment fit entirely within a designated availability block
    select * from dl_availability
    where
      startAvailability <= pStart
      and endAvailability >= pEnd
      and dayOfWeek = dayOfWeek(aStartTime)
  ) then

    return 5;
  end if;
if exists (
    -- is there no other appointment that conflicts with it
  select * from dl_appointment
    where
      aStartTime between startTime and endTime
      or aEndTime between startTime and endTime
) then
  return 6;
end if;
if exists (
    -- this timeblock is not locked by another user
    select * from dl_appointmentLock
    where
      (startTime < aStartTime and aStartTime < endTime) -- can't use "between" operator here either
      or (startTime < aEndTime and aEndTime < endTime)
) then
  return 7;
end if;


  return 0;

end //