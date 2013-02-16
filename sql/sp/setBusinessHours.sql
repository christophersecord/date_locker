drop procedure if exists dl_setBusinessHours;

DELIMITER //

/** setBusinessHours
 * @hint sets blocks of time when appointments are possible on a given day of week.
 * openBlocks is a string of comma-delimited times in the format, HH:MM
 */
create procedure dl_setBusinessHours(
  in selectedDayOfWeek int,
  in openBlocks varchar(250)
)
begin

  declare top varchar(5);

  -- clear existing hours for this day
  delete from dl_businessHours
  where dayOfWeek = selectedDayOfWeek;

  -- loop through new open blocks
  while dl_listLen(openBlocks) > 0 do

    set top = dl_listFirst(openBlocks);
    set openBlocks = dl_listRest(openBlocks);

    insert dl_businessHours (dayOfWeek,startAvailability,endAvailability)
    values (
      selectedDayOfWeek,
      str_to_date(concat('1900-01-01 ',top),'%Y-%m-%d %H:%i'),
      str_to_date(concat('1900-01-01 ',dl_listFirst(openBlocks)),'%Y-%m-%d %H:%i')
    );

    set openBlocks = dl_listRest(openBlocks);

  end while;


end //
