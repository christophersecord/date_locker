/**
 * a base class for SP test script classes to extend
 *
 * @author christophersecord
 * @date 20130621
 * @language ColdFusion
 * @platform mxunit
 */
component extends="dl.test.framework.mxunit.framework.TestCase" {

/**
 * runs once before any tests begin
 * configures application to allow appointments tomorrow
 */
public void function beforeTests() {

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

}