/** function for date_locker project
 * @author christophersecord
 * @date 20130319
 * @language SQL
 * @platform mySQL
 */
drop function if exists dl_isAvailableReason;

DELIMITER //

/** isAvailableReason
 * if an appointment time is not available, returns a string indicating why
 */
create function dl_isAvailableReason (aStartTime datetime, aEndTime datetime)
returns varchar(100)
begin

  declare pStart datetime
  default str_to_date(concat('1900-01-01 ',hour(aStartTime),':',minute(aStartTime)),'%Y-%m-%d %H:%i');

  -- note, the end time is set to one minute before the input end time so that midnight isn't seen as the next day
  declare pEnd datetime 
  default date_add(str_to_date(concat('1900-01-01 ',hour(aEndTime),':',minute(aEndTime)),'%Y-%m-%d %H:%i'),interval -1 minute);

  declare pStartTimeOffset int;

  -- appointment must be far enough in advance
  if aStartTime < dl_earliestAvailability() then
    return 'insufficient advance notice';
  end if;

  if dl_isAvailable(aStartTime,aEndTime) then
    return 'available';
  end if;

  -- end time must be greater than start time and be on the same day
  if (aEndTime <= aStartTime) || (day(aStartTime) != day(aEndTime)) then
    return 'invalid timespan';
  end if;

  -- startTime must start on an hour or half-hour boundry (as defined by the config variable)
  select minute(aStartTime)%intVal
  into pStartTimeOffset
  from dl_config where varName='apt_start_times';

  if pStartTimeOffset != 0 then
    return 'invalid start time boundry';
  end if;

  -- appointment length must be an approved duration
  if not exists (
    select *
    from dl_appointmentDuration
    where minutes = minute(timeDiff(aStartTime,aEndTime)) + hour(timeDiff(aStartTime,aEndTime))*60
  ) then
    return 'invalid duration';
  end if;

  if not exists (
    -- does the proposed appointment fit entirely within a designated availability block
    select * from dl_businessHours
    where
      startAvailability <= pStart
      and endAvailability >= pEnd
      and dayOfWeek = dayOfWeek(aStartTime)
  ) then

    return 'outside business hours';
  end if;

  if exists (
    -- is there no other appointment that conflicts with it
  select * from dl_appointment
    where
      (startTime <= aStartTime and aStartTime < endTime)
      or (startTime < aEndTime and aEndTime <= endTime)
      or (startTime > aStartTime and aEndTime > endTime)
  ) then
    return 'conflicting appointment';
  end if;

  if exists (
    -- this timeblock is not locked by another user
    select * from dl_appointmentLock
    where
      (startTime <= aStartTime and aStartTime < endTime)
      or (startTime < aEndTime and aEndTime <= endTime)
      or (startTime > aStartTime and aEndTime > endTime)
  ) then
    return 'time block locked';
  end if;


  return 'ERROR! isAvailable() and isAvailableReason() disagree!';

end //