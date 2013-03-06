/** stored procedure for dana_lupo project
 * @author christophersecord
 * @date 20130302
 * @language SQL
 * @platform mySQL
 */
drop procedure if exists dl_clientGet;

DELIMITER //

/** clientGet
 * gets all info about a client given their clientID
 */
create procedure dl_clientGet (
  in pClientID int
)
begin

  select c.emailAddress, l.loginTime, l.logoutTime
  from dl_client c

  left join dl_login l
  on c.clientID = l.clientID
    and l.clientID = pClientID
    and l.loginTime = (
      select max(loginTime)
      from dl_login
      where clientID = pClientID
    )

  where c.clientID = pClientID;

end //

