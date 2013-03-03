/** stored procedure for dana_lupo project
 * @author christophersecord
 * @date 20130302
 * @language SQL
 * @platform mySQL
 */
drop procedure if exists dl_clientLogin;

DELIMITER //

/** clientLogin
 * returns a loginTokenString (a combination of loginID at token) if a username/password matches a client
 */
create procedure dl_clientLogin (
  in pEmailAddress varchar(250),
  in plainTextPasswd varchar(250),

  out loginTokenString varchar(41)
)
begin

  declare pClientID int;
  declare pLoginID int;
  declare pLoginToken char(36);

  select clientID
  into pClientID
  from dl_client
  where emailAddress = pEmailAddress
    and passwd = sha2(plainTextPasswd,224);

  if (pClientID is not null) then
    set pLoginToken = uuid();

    -- TODO: set logout time in the future
    insert dl_login (loginToken,clientID,loginTime,logOutTime)
    values (pLoginToken,pClientID,now(),now());

    set pLoginID = last_insert_id();
    set loginTokenString = concat(pLoginID,',',pLoginToken);

  end if;
end //

