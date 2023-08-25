/** stored procedure for date_locker project
 * @author christophersecord
 * @date 20130302
 * @language SQL
 * @platform mySQL
 */
drop procedure if exists dl_clientLogin;

DELIMITER //

/** clientLogin
 * returns a loginTokenString (a combination of loginID at token) to record that a client has logged in
 */
create procedure dl_clientLogin (
  in pClientID varchar(250),

  out loginTokenString varchar(41)
)
begin

  declare pLoginID int;
  declare pLoginToken char(36);

  set pLoginToken = uuid();

  -- TODO: lookup client preferences for when logout will occur
  insert dl_login (loginToken,clientID,loginTime,logOutTime)
  values (pLoginToken,pClientID,now(),now());

  set pLoginID = last_insert_id();
  set loginTokenString = concat(pLoginID,',',pLoginToken);

end //

