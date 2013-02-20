/** function for dana_lupo project
 * @author christophersecord
 * @date 20130319
 * @language SQL
 * @platform mySQL
 */
drop function if exists dl_isAvailable;

DELIMITER //

/** isAvailable
 * returns true if the proposed time block is available as an appointment and is a valid appointment
 */
create function dl_isAvailable(aStartTime datetime, aEndTime datetime)
returns bit
begin

  declare pStart datetime
  default str_to_date(concat('1900-01-01 ',hour(aStartTime),':',minute(aStartTime)),'%Y-%m-%d %H:%i');

  -- note, the end time is set to one minute before the input end time so that midnight isn't seen as the next day
  declare pEnd datetime 
  default date_add(str_to_date(concat('1900-01-01 ',hour(aEndTime),':',minute(aEndTime)),'%Y-%m-%d %H:%i'),interval -1 minute);

  declare pStartTimeOffset int;

  -- appointment must be far enough in advance
  if aStartTime < dl_earliestAvailability() then
    return 0;
  end if;

  -- end time must be greater than start time and be on the same day
  if (aEndTime <= aStartTime) || (day(aStartTime) != day(aEndTime)) then
    return 0;
  end if;

  -- startTime must start on an hour or half-hour boundry (as defined by the config variable)
  select minute(aStartTime)%intVal
  into pStartTimeOffset
  from dl_config where varName='apt_start_times';

  if pStartTimeOffset != 0 then
    return 0;
  end if;

  -- appointment length must be an approved duration
  if not exists (
    select *
    from dl_appointmentDuration
    where minutes = minute(timeDiff(aStartTime,aEndTime)) + hour(timeDiff(aStartTime,aEndTime))*60
  ) then
    return 0;
  end if;

  -- appointment must be on an allowed time block
  if (

    exists (
      -- the appointment is inside normal business hours
      select *
      from dl_businessHours
      where
        startAvailability <= pStart
        and endAvailability >= pEnd
        and dayOfWeek = dayOfWeek(aStartTime)

    ) or exists (
      -- the appointment is inside a designated availability block
      -- TODO: this code and the business hours code needs to be combined
      select * from dl_appointmentAvailabilityBlock
      where
        appointmentsAllowed = 1
        and startTime <= aStartTime and aEndTime <= endTime
    )

  ) and not exists (
    -- is there no other appointment that conflicts with it
    select * from dl_appointment
    where
      (startTime <= aStartTime and aStartTime < endTime)
      or (startTime < aEndTime and aEndTime <= endTime)
      or (startTime > aStartTime and aEndTime > endTime)

  ) and not exists (
    -- the time has not been blocked off as unavailable
    select * from dl_appointmentAvailabilityBlock
    where
      appointmentsAllowed = 0
      and (
        (startTime <= aStartTime and aStartTime < endTime)
        or (startTime < aEndTime and aEndTime <= endTime)
        or (startTime > aStartTime and aEndTime > endTime)
      )

  ) and not exists (
    -- this timeblock is not locked by another user
    select * from dl_appointmentLock
    where
      (startTime <= aStartTime and aStartTime < endTime)
      or (startTime < aEndTime and aEndTime <= endTime)
      or (startTime > aStartTime and aEndTime > endTime)
  ) then

    return 1;

  end if;

  return 0;

end //