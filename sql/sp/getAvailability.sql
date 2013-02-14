drop procedure if exists dl_getAvailability;

DELIMITER //

create procedure dl_getAvailability(in selectedDay date)
begin

  declare pStart datetime default selectedDay;
  declare pEnd datetime;

  create temporary table availability (
    startTime datetime not null
  );

  set @i:= 0;

  -- Really? This is how you do a loop in MySQL? Seriously?
  -- loop through all time blocks in the current day
  addRows: loop

    -- is the smallest possible appointment available at this time?
    set pEnd = date_add(pStart, interval 30 minute);
    if dl_isAvailable(pStart,pEnd)
    then 

      insert availability
      values (pStart);
 
    end if;

    set @i:= @i + 1;

    -- TODO: this loops in 30 minute steps. It should be configurable
    set pStart = date_add(pStart, interval 30 minute);

    -- this is how you end a loop in MySQL??
    if @i >= 48 then
      leave addRows;
    end if;

  end loop addRows;

  select startTime from availability;

  drop table availability;

end //
