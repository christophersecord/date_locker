/** stored procedure for dana_lupo project
 * @author christophersecord
 * @date 20130319
 * @language SQL
 * @platform mySQL
 */
drop procedure if exists dl_appointmentAvailabilityBlockDelete;

DELIMITER //

/** appointmentAvailabilityBlockDelete
 * deletes an appointment availability block
 */
create procedure dl_appointmentAvailabilityBlockDelete (
  in pBlockID int
)
begin

  delete from dl_appointmentAvailabilityBlock
  where blockID = pBlockID;

end //

