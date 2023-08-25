/** stored procedure for date_locker project
 * @author christophersecord
 * @date 20130302
 * @language SQL
 * @platform mySQL
 */
drop procedure if exists dl_clientLogout;

DELIMITER //

/** clientLogout
 * logs out a client
 */
create procedure dl_clientLogout (
  in loginTokenString varchar(41)
)
begin

  -- TODO: additional where clause constraint that verifies user isn't already logged out
  update dl_login
  set logoutTime = now()
  where loginID = dl_listFirst(loginTokenString)
    and loginToken = dl_listRest(loginTokenString);

end //

