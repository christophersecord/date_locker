/** stored procedure for date_locker project
 * @author christophersecord
 * @date 20130302
 * @language SQL
 * @platform mySQL
 */
drop procedure if exists dl_clientReturn;

DELIMITER //

/** clientReturn
 * when a client returns after an initial login, this procedure looks up their clientID and loginTime
 * given their login token
 */
create procedure dl_clientReturn (
  in loginTokenString varchar(41),

  out pClientID int,
  out pLoginTime datetime
)
begin

  select clientID, loginTime
  into pClientID, pLoginTime
  from dl_login

  where loginID = dl_listFirst(loginTokenString)
    and loginToken = dl_listRest(loginTokenString);


  if (pClientID is not null) then

    -- TODO: set logout time in the future
    update dl_login
    set logoutTime = now()
    where loginID = dl_listFirst(loginTokenString);

  end if;

end //

