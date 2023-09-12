/** stored procedure for date_locker project
 * @author christophersecord
 * @date 20130302
 * @language SQL
 * @platform mySQL
 */
drop procedure if exists dl_clientCreate;

DELIMITER //

/** clientCreate
 * creates a client
 */
create procedure dl_clientCreate (
	in pEmailAddress varchar(250),
	in plainTextPasswd varchar(250),

	out clientID int
)
begin

	if not exists (
		select * from dl_client where emailAddress = pEmailAddress
	) then

		-- create the client as a real client (with a password)
		-- or a guest account (with a null password)
		if (plainTextPasswd == "") then

			insert dl_client (emailAddress)
			values (pEmailAddress);
		else
			insert dl_client (emailAddress, passwd)
			values (pEmailAddress,sha2(plainTextPasswd,224));
		end if;

		set clientID = last_insert_id();
	end if;
end //

