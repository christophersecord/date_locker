/** stored procedure for dana_lupo project
 * @author christophersecord
 * @date 20130302
 * @language SQL
 * @platform mySQL
 */
drop procedure if exists dl_clientReturn;

DELIMITER //

/** clientReturn
 * when a client returns after an initial login, this procedure looks up their clientID and username
 * given their login token
 */
create procedure dl_clientReturn (
  in loginTokenString varchar(41),

  out pClientID int,
  out pEmailAddress varchar(250),
  out pLoginTime datetime
)
begin

  select c.clientID, c.emailAddress, l.loginTime
  into pClientID, pEmailAddress, pLoginTime
  from dl_login l

  join dl_client c
  on l.clientID = l.clientID

  where loginID = dl_listFirst(loginTokenString)
    and loginToken = dl_listRest(loginTokenString);


  if (pClientID is not null) then

    -- TODO: set logout time in the future
    update dl_login
    set logoutTime = now()
    where loginID = dl_listFirst(loginTokenString);

  end if;

end //

