/** base tables for dana_lupo project
 * @author christophersecord
 * @date 20130203
 * @language SQL
 * @platform mySQL
 */

/** appointment
 * @hint one row per scheduled appointment or blocked time
 */
create table dl_appointment (
	appointmentID int not null auto_increment primary key,
	clientID int not null
)