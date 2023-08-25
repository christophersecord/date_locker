/** stored procedure for date_locker project
 * @author christophersecord
 * @date 20130319
 * @language SQL
 * @platform mySQL
 */
drop procedure if exists dl_appointmentAvailabilityBlockList;

DELIMITER //

/** appointmentAvailabilityBlockList
 * lists all appointment availability blocks for a given date
 */
create procedure dl_appointmentAvailabilityBlockList (
  in pDate date
)
begin

  select
    blockID,
    startTime,
    endTime,
    appointmentsAllowed
  from dl_appointmentAvailabilityBlock
  where date(startTime) = pDate
  order by startTime, endTime;

end //

