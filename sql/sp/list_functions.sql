drop function if exists dl_listRest;
drop function if exists dl_listFirst;
drop function if exists dl_listLen;

DELIMITER //

/** listLen
 * @hint counts the number of items in a comma-delimited list
 */
create function dl_listLen(list varchar(250))
returns int
begin

  declare i int default 0;

  if length(list) > 0 then
    set i = 1;
  end if;

  while locate(',',list) > 0 do

    set i = i + 1;
    set list = substring(list,locate(',',list)+1);

  end while;

  return i;

end //

/** listFirst
 * @hint returns the first item in a comma-delimited list
 */
-- TODO: should skip empty items or leading "," as in, ",one,two"
create function dl_listFirst(list varchar(250))
returns varchar(250)
begin

  if locate(',',list) = 0 then
    return list;
  else
    return substring(list,1,locate(',',list)-1);
  end if;

end //

/** listRest
 * @hint
 */
create function dl_listRest(list varchar(250))
returns varchar(250)
begin

  if locate(',',list) = 0 then
    return '';
  else
    return substring(list,locate(',',list)+1);
  end if;


end //