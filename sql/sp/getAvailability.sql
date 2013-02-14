drop procedure if exists dl_getAvailability;

DELIMITER //

create procedure dl_getAvailability(in selectedDay date)
begin

  create temporary table availability (
    startTime datetime not null
  );

  set @i:= 0;
  set @availabilityDate:= str_to_date('1900-01-01 00','%Y-%m-%d %H');
  set @realDate:= str_to_date(concat(year(selectedDay),'-',month(selectedDay),'-',day(selectedDay),' 00'),'%Y-%m-%d %H');

  -- Really? This is how you do a loop in MySQL? Seriously?
  -- loop through all time blocks in the current day
  addRows: loop

    if exists (
      select * from dl_availability
      where
        startAvailability <= @availabilityDate
        and endAvailability > @availabilityDate
    ) and not exists (
      select * from dl_appointment
      where
        @realDate between startTime and endTime
    ) then

      insert availability
      values (@realDate);
 
    end if;

    set @i:= @i + 1;

    -- TODO: this loops in 30 minute steps. It should be configurable
    set @realDate:= date_add(@realDate, interval 30 minute);
    set @availabilityDate:= date_add(@availabilityDate, interval 30 minute);

    if @i >= 48 then
      leave addRows;
    end if;

  end loop addRows;

  select startTime from availability;

  drop table availability;

end //
