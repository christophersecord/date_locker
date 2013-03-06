/** stored procedure for dana_lupo project
 * @author christophersecord
 * @date 20130305
 * @language SQL
 * @platform mySQL
 */
drop procedure if exists dl_clientAuthenticate;

DELIMITER //

/** clientAuthenticate
 * checks a username/password and returns the corresponding client if found
 */
create procedure dl_clientAuthenticate (
  in pEmailAddress varchar(250),
  in plainTextPasswd varchar(250),

  out pClientID int
)
begin

  select clientID
  into pClientID
  from dl_client
  where emailAddress = pEmailAddress
    and passwd = sha2(plainTextPasswd,224);

end //

