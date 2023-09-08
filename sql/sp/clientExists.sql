/** function for date_locker project
 * @author christophersecord
 * @date 20130305
 * @language SQL
 * @platform mySQL
 */
drop function if exists dl_clientExists;

DELIMITER //

/** clientExists
 * returns true if the client (identified by an email address) already exists
 */
create function dl_clientExists (
	pEmailAddress varchar(250)
)
returns bit
reads sql data
begin

  if exists (
    select clientID
    from dl_client
    where emailAddress = pEmailAddress
  ) then

    return 1;

  else
    
    return 0;

  end if;

end //