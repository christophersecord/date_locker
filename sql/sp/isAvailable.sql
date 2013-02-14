drop function if exists dl_isAvailable;

DELIMITER //

create function dl_isAvailable(aStartTime datetime, aEndTime datetime)
returns bit
begin

  set @aStartTime:= str_to_date(concat('1900-01-01 ',hour(aStartTime),':',minute(aStartTime)),'%Y-%m-%d %H:%i');
  set @aEndTime:= str_to_date(concat('1900-01-01 ',hour(aEndTime),':',minute(aEndTime)),'%Y-%m-%d %H:%i');

  if exists (
    -- does the proposed appointment fit entirely within an 
    select * from dl_availability
    where
      startAvailability <= @aStartTime
      and endAvailability >= @aEndDate
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
