/** function for date_locker project
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
create function dl_isAvailable (
	aStartTime datetime,
	aEndTime datetime
)
returns bit
begin

  -- pStart and pEnd are the argument start and end times without the day portion of the timestamp
  -- for use in comparing to business hours
  declare pStart datetime
  default str_to_date(concat('1900-01-01 ',hour(aStartTime),':',minute(aStartTime)),'%Y-%m-%d %H:%i');

  -- note, the end time is set to one minute before the input end time so that midnight isn't seen as the next day
  declare pEnd datetime 
  default date_add(str_to_date(concat('1900-01-01 ',hour(aEndTime),':',minute(aEndTime)),'%Y-%m-%d %H:%i'),interval -1 minute);

  -- these variables are used to loop through the proposed appointment in minimum-sized time blocks (for 
  -- example, 30-minute blocks), each of which is validated to make sure it its insie either a business hours
  -- block or a special availability block
  declare raStartTime datetime default aStartTime;
  declare raEndTime datetime;
  declare rpStartTime datetime default pStart;
  declare rpEndTime datetime;
  declare minAptInterval int;

  -- appointment must be far enough in advance
  if aStartTime < dl_earliestAvailability() then
    return 0;
  end if;

  -- end time must be greater than start time and be on the same day
  if (aEndTime <= aStartTime) || (day(aStartTime) != day(aEndTime)) then
    return 0;
  end if;

  -- startTime must start on an hour or half-hour boundry (as defined by the config variable)
  if not exists (
    select *
    from dl_config
    where varName = 'apt_start_times'
      and minute(aStartTime)%intVal = 0
  ) then
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

  -- if there is a special availability block on the same day,
  -- and the appointment is not the smallest allowable duration
  if exists (

    -- special availability block on the same day
    select * from dl_appointmentAvailabilityBlock
    where
      appointmentsAllowed = 1
      and dateDiff(aStartTime,startTime) = 0

      -- the appointment is not the smallest allowable duration
      and time_to_sec(timeDiff(aEndTime,aStartTime))/60 <> (select min(minutes) from dl_appointmentduration)

  ) then

    -- what is the minimum appointment size (typically it's a 30-minute appointment)
    select min(minutes) into minAptInterval from dl_appointmentDuration;

    -- loop through all possible minimum appointments that fit into the real appointment
    while (raStartTime < aEndTime) do

      -- create appointments of that size
      set raEndTime = date_add(raStartTime, interval minAptInterval minute);
      set rpEndTime = date_add(rpStartTime, interval minAptInterval minute);

      if not exists (
        -- is the appointment entirely inside a business hours block
        select *
        from dl_businessHours
        where
          startAvailability <= rpStartTime
          and endAvailability >= rpEndTime
          and dayOfWeek = dayOfWeek(aStartTime)
      ) and not exists (
        -- is the appointment entirely inside a special availability block
        select * from dl_appointmentAvailabilityBlock
        where
          appointmentsAllowed = 1
          and startTime <= raStartTime and raEndTime <= endTime

      ) then
        return 0;
      end if;

      -- loop by minAptInterval minutes
      set raStartTime = date_add(raStartTime, interval minAptInterval minute);
      set rpStartTime = date_add(rpStartTime, interval minAptInterval minute);
      
    end while;

  -- there's no special availability block on this day or the appointment is the smallest possible duration,
  -- use the simpler business hours check
  else

    if not exists (
      -- is the appointment entirely inside a business hours block
      select *
      from dl_businessHours
      where
        startAvailability <= pStart
        and endAvailability >= pEnd
        and dayOfWeek = dayOfWeek(aStartTime)
    ) and not exists (
      -- is the appointment entirely inside a special availability block
      select * from dl_appointmentAvailabilityBlock
      where
        appointmentsAllowed = 1
        and startTime <= aStartTime and aEndTime <= endTime

    ) then
      return 0;
    end if;

  end if;

  if not exists (
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