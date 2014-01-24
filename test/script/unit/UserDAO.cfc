/**
 * unit tests for dana_lupo project, testing data access objects
 *
 * requires the mxUnit framework installed under mxunit.framework
 * http://localhost/dl/test/unit/DAO.cfc?method=runtestremote&output=html
 *
 * These tests check the functionality of the DAOs. Note that instead of transaction rollbacks,
 * these tests nuke the database.
 *
 * @author christophersecord
 * @date 20130312
 * @language ColdFusion
 * @platform mxunit
 */
component extends="dl.test.framework.mxunit.framework.TestCase" {

request.comproot = "dl.comp";

/**
 * runs once before any tests begin
 * instantiates DAO objects used by other tests.
 * defines constants for time blocks used in tests.
 * configures application to allow appointments tomorrow
 */
public void function beforeTests() {

	// DAO objects to be tested
	userDAO = createObject("component",request.compRoot & ".org.secord.dana_lupo.UserDAO");
	securityDAO = createObject("component",request.compRoot & ".org.secord.dana_lupo.SecureDAO");
	appointmentDAO = createObject("component",request.compRoot & ".org.secord.dana_lupo.AppointmentDAO");
	calendarDAO = createObject("component",request.compRoot & ".org.secord.dana_lupo.CalendarDAO");
	appointmentLockDAO = createObject("component",request.compRoot & ".org.secord.dana_lupo.AppointmentLockDAO");

	// business hours time block
	tbBusinessHours = "10:00,12:00,13:00,16:00";

	// an extra availability block
	tbAvailability = "16:00,18:00";

	// dates for the next three days
	dtTomorrow = dateFormat(dateAdd("d",1,now()),"yyyy-mm-dd");
	dtDayOne = dateFormat(dateAdd("d",2,now()),"yyyy-mm-dd");
	dtDayTwo = dateFormat(dateAdd("d",3,now()),"yyyy-mm-dd");

	// appointment time blocks
	tbMorning1 = "10:00,11:00";
	tbMorning2 = "10:30,11:30";
	tbMorning3 = "11:00,12:00";

	afternoon1 = "13:00,14:00";
	afternoon2 = "14:00,15:00";


	// clear all appointment Durations
	var q = new Query();
	q.setDataSource("danalupo");
	q.setSQL("delete from dl_appointmentDuration");
	q = q.execute();

	// for testing, allow 30, 60, 90, and 120 minute appointments
	var q = new Query();
	q.setDataSource("danalupo");
	q.setSQL("insert dl_appointmentDuration values (30)");
	q = q.execute();

	var q = new Query();
	q.setDataSource("danalupo");
	q.setSQL("insert dl_appointmentDuration values (60)");
	q = q.execute();

	var q = new Query();
	q.setDataSource("danalupo");
	q.setSQL("insert dl_appointmentDuration values (90)");
	q = q.execute();

	var q = new Query();
	q.setDataSource("danalupo");
	q.setSQL("insert dl_appointmentDuration values (120)");
	q = q.execute();

	// set configuration to allow appointments tomorrow morning.
	// otherwise, if tests are run after 6:00 PM, they will fail
	var plusOneHour = "01-01-1900 " & timeFormat(dateAdd("h",1,now()),"HH:MM");
	var q = new Query();
	q.setDataSource("danalupo");
	q.setSQL("
		update dl_config
		set dateVal = :plusOneHour
		where varName = 'apt_advance_stt'
	");
	q.addParam(name="plusOneHour",value=plusOneHour,cfsqltype="cf_sql_timestamp");
	q = q.execute();


}

/**
 * runs before every test
 * deletes data from tables (had trouble getting transaction rollbacks to work in mysql)
 */
public void function setup() {
	// dl_businessHours
	var q = new Query();
	q.setDataSource("danalupo");
	q.setSQL("delete from dl_businessHours");
	q = q.execute();

	// dl_appointmentAvailabilityBlock
	var q = new Query();
	q.setDataSource("danalupo");
	q.setSQL("delete from dl_appointmentAvailabilityBlock");
	q = q.execute();

	// dl_appointmentLock
	var q = new Query();
	q.setDataSource("danalupo");
	q.setSQL("delete from dl_appointmentLock");
	q = q.execute();

	// dl_appointment
	var q = new Query();
	q.setDataSource("danalupo");
	q.setSQL("delete from dl_appointment");
	q = q.execute();

	// dl_login
	var q = new Query();
	q.setDataSource("danalupo");
	q.setSQL("delete from dl_login");
	q = q.execute();

	// dl_client
	var q = new Query();
	q.setDataSource("danalupo");
	q.setSQL("delete from dl_client");
	q = q.execute();


}

/* manual setup functions
 * if several tests need the same sort of setup, that code is in private methods here
 * ================================================================================================
 */

/**
 * creates a user
 * when each test runs, there will be no users in the DB. Tests will call this method to quickly
 * create a user to test with.
 */
private numeric function createUser(string email="clientID1@email.com", string password="1234") {

	return userDAO.clientCreate(email,password);
}

/**
 * sets business hours to morning and afternoon on tomorrow and day two
 * day two will have the additional availability block tacked on
 */
private void function setBusinessHours() {

	calendarDAO.businessHoursSet(dayOfWeek(dtTomorrow),tbBusinessHours);
	calendarDAO.businessHoursSet(dayOfWeek(dtDayTwo),tbBusinessHours);

	calendarDAO.appointmentAvailabilityBlockCreate(listFirst(tbAvailability),listLast(tbAvailability));
}


/* tests
 * ================================================================================================
 */

/**
 * test UserDAO and SecureDAO
 */
public void function user() {

	var client1Email = "client1@email.com";
	var client1Passwd = "passwd";

	// client 1 doesn't exist
	assertFalse(userDAO.clientExists(client1Email),"client1 doesn't exist");

	// create client 1
	var client1ID = userDAO.clientCreate(client1Email,client1Passwd);

	// a valid clientID is returned
	assert(isNumeric(client1ID) && client1ID > 0,"client1 created successfully");

	// client 1 now exists
	assertTrue(userDAO.clientExists(client1Email),"client1 now exists");

	// the username/password lookup works
	assert(securityDAO.clientAuthenticate(client1Email,"incorrectPassword") == 0,"incorrect password, client not found");
	assert(securityDAO.clientAuthenticate(client1Email,client1Passwd) > 0,"correct password, client found");

	var q = userDAO.clientGet(client1ID);

	assertTrue(q.recordCount,"client found");
	assertEquals(client1Email,q.emailAddress[1],"found the correct client");

	clientID2 = userDAO.clientCreate("clientID2@email.com","secretpassword");

	assert(isNumeric(clientID2),"clientID2 is numeric");
	assertFalse(clientID2 == 0,"clientID2 is non-zero");

	q = userDAO.clientGet(clientID2);

	assertTrue(q.recordCount,"client 2 found");
	assertEquals("clientID2@email.com",q.emailAddress[1],"found the correct client for client 2");
}

public void function user_exists() {

	assertFalse(userDAO.clientExists("invalid@email.com"),"nonexistant client is nonexistant");

	var client1Email = "client1@email.com";
	var client1Passwd = "passwd";
	this.createUser(client1Email,client1Passwd);

	assertTrue(userDAO.clientExists(client1Email),"existant client existx");

}



}