/**
 * unit tests for date_locker project, testing data access objects
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
	clientDAO = createObject("component",request.compRoot & ".org.secord.date_locker.clientDAO");
	securityDAO = createObject("component",request.compRoot & ".org.secord.date_locker.SecureDAO");
	appointmentDAO = createObject("component",request.compRoot & ".org.secord.date_locker.AppointmentDAO");
	calendarDAO = createObject("component",request.compRoot & ".org.secord.date_locker.CalendarDAO");
	appointmentLockDAO = createObject("component",request.compRoot & ".org.secord.date_locker.AppointmentLockDAO");

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
	q.setDataSource("dl");
	q.setSQL("delete from dl_appointmentDuration");
	q = q.execute();

	// for testing, allow 30, 60, 90, and 120 minute appointments
	var q = new Query();
	q.setDataSource("dl");
	q.setSQL("insert dl_appointmentDuration values (30)");
	q = q.execute();

	var q = new Query();
	q.setDataSource("dl");
	q.setSQL("insert dl_appointmentDuration values (60)");
	q = q.execute();

	var q = new Query();
	q.setDataSource("dl");
	q.setSQL("insert dl_appointmentDuration values (90)");
	q = q.execute();

	var q = new Query();
	q.setDataSource("dl");
	q.setSQL("insert dl_appointmentDuration values (120)");
	q = q.execute();

	// set configuration to allow appointments tomorrow morning.
	// otherwise, if tests are run after 6:00 PM, they will fail
	var plusOneHour = "01-01-1900 " & timeFormat(dateAdd("h",1,now()),"HH:MM");
	var q = new Query();
	q.setDataSource("dl");
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
	q.setDataSource("dl");
	q.setSQL("delete from dl_businessHours");
	q = q.execute();

	// dl_appointmentAvailabilityBlock
	var q = new Query();
	q.setDataSource("dl");
	q.setSQL("delete from dl_appointmentAvailabilityBlock");
	q = q.execute();

	// dl_appointmentLock
	var q = new Query();
	q.setDataSource("dl");
	q.setSQL("delete from dl_appointmentLock");
	q = q.execute();

	// dl_appointment
	var q = new Query();
	q.setDataSource("dl");
	q.setSQL("delete from dl_appointment");
	q = q.execute();

	// dl_login
	var q = new Query();
	q.setDataSource("dl");
	q.setSQL("delete from dl_login");
	q = q.execute();

	// dl_client
	var q = new Query();
	q.setDataSource("dl");
	q.setSQL("delete from dl_client");
	q = q.execute();


}

/* manual setup functions
 * if several tests need the same sort of setup, that code is in private methods here
 * ================================================================================================
 */

/**
 * creates a client
 * when each test runs, there will be no clients in the DB. Tests will call this method to quickly
 * create a client to test with.
 */
private numeric function createClient(string email="clientID1@email.com", string password="1234") {

	return clientDAO.clientCreate(email,password);
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

}
