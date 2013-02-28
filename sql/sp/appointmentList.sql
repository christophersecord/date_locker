/** stored procedure for dana_lupo project
 * @author christophersecord
 * @date 20130319
 * @language SQL
 * @platform mySQL
 */
drop procedure if exists dl_appointmentList;

DELIMITER //

/** appointmentList
 * returns all appointments for a specific date
 */
create procedure dl_appointmentList (
  in pDate date
)
begin

  select appointmentID,
    c.ClientID, c.emailAddress,
    a.startTime, a.endTime,
    a.bookedOn,
    a.googleCalendarGUID,
    a.memo
  from dl_appointment a
  join dl_client c on a.clientID = c.clientID
  where date(startTime) = pDate
  order by startTime, endTime
 
end //

