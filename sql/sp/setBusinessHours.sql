drop procedure if exists dl_setBusinessHours;

DELIMITER //

/** setBusinessHours
 * @hint 
 */
create procedure dl_setBusinessHours(
  in selectedDayOfWeek int,
  in openBlocks varchar(250)
)
begin

  -- clear existing hours for this day
  delete from dl_availability
  where dayOfWeek = selectedDayOfWeek;

  -- loop through new open blocks
/*
  set @newAvailableBlocks = '8:00,11:00,13:30,17:30';

  while (locate(',', @newAvailableBlocks) > 0)
  DO
      SET @value = ELT(1, @myArrayOfValue);
      SET @value = SUBSTRING(@myArrayOfValue, LOCATE(',',@myArrayOfValue) + 1);

      INSERT INTO `EXEMPLE` VALUES(@value, 'hello');
  END WHILE;
*/

end //
