drop function if exists dl_isAvailable;

DELIMITER //

create function dl_isAvailable(aStartTime datetime, aEndTime datetime)
returns bit
begin

  declare pStart datetime
  default str_to_date(concat('1900-01-01 ',hour(aStartTime),':',minute(aStartTime)),'%Y-%m-%d %H:%i');
  
  declare pEnd datetime 
  default str_to_date(concat('1900-01-01 ',hour(aEndTime),':',minute(aEndTime)),'%Y-%m-%d %H:%i');

  -- end time must be greater than start time
  if aEndTime <= aStartTime then
    return 0;
  end if;

  -- TODO: startTime must start on an hour or half-hour boundry
  -- TODO: appointment length must be an approved time

  if exists (
    -- does the proposed appointment fit entirely within an 
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
  ) then

    return 1;

  end if;

  return 0;


end //
