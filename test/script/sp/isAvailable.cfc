/**
 * tests the isAvailable() function
 *
 * requires the mxUnit framework installed under mxunit.framework
 *
 * @author christophersecord
 * @date 20130527
 * @language ColdFusion
 * @platform mxunit
 *
 * @hint this test script is oddly structured and deserves some explanation. It's based on a plan detailed in
 * appointmentTestPlan.png Three days represent three scenarios of business hours, availability hours, and existing
 * appointments. My goal with this test script was to be able to make a change to the plan and easily update this script
 * to reflect that change. To that end, I do not want data about, for example, the appointments to be tested, to be
 * buried down in the code somewhere. So instead, all data like start times and end times is contained in the
 * beforeTests() method, in a format that's easily modifiable (in the case of appointments, it's a multi-line string
 * that I just copy/paste from the plan document). Then, there are private methods that process that data and actually
 * perform the mxunit assertions.
 */
component extends="_SP" {

variables.days = structNew(); // data about the days to be used in testing
variables.appointments = structNew(); // data about the appointments to be tested, and the expected results of each test

/**
 * populates the days and appointments structures with data to run each test
 */
public void function beforeTests() {
	super.beforeTests();

	// the setup function in _SP nukes the database
	super.setup();

	variables.days = structNew();
	variables.days.Day1 = structNew();
	variables.days.Day1.calDate = dateAdd("d",2,now());
	variables.days.Day1.BusinessHours = "9:00,11:00";
	variables.days.Day1.AvailabilityHours = "11:30,13:30";

	variables.days.Day2 = structNew();
	variables.days.Day2.calDate = dateAdd("d",3,now());
	variables.days.Day2.BusinessHours = "9:00,11:00";
	variables.days.Day2.AvailabilityHours = "11:00,13:30";

	variables.days.Day3 = structNew();
	variables.days.Day3.calDate = dateAdd("d",4,now());
	variables.days.Day3.BusinessHours = "9:00,11:00";
	variables.days.Day3.AvailabilityHours = "11:00,13:30";
	variables.days.Day3.ExistingAppointment1 = "10:00,12:00";
	variables.days.Day3.ExistingAppointment2 = "12:30,13:00";

	// list of appointments and expected results copy/pasted from the test plan
	var appointmentData = "
		A01	8:00-8:30	0	0	0
		A02	8:00-9:00	0	0	0
		A03	8:30-9:30	0	0	0
		A04	9:00-10:00	1	1	1
		A05	9:30-10:30	1	1	0
		A06	10:00-11:00	1	1	0
		A07	10:30-11:30	0	1	0
		A08	10:30-12:00	0	1	0
		A09	11:00-11:30	0	1	0
		A10	11:00-12:00	0	1	0
		A11	11:30-12:30	1	1	0
		A12	12:00-12:30	1	1	1
		A13	12:00-13:00	1	1	0
		A14	12:00-13:30	1	1	0
		A15	12:30-13:30	1	1	0
		A16	13:00-14:00	0	0	0
		A17	13:30-14:30	0	0	0
		A18	14:00-14:30	0	0	0
	";

	variables.appointments = prepareAsserts(appointmentData);


	// set business hours, availability hours, and an appointment for test days
	/*
	var q = new Query();
	q.setDataSource("dl");
	q.setSQL("
		insert into dl_businessHours (dayOfWeek,startAvailability,endAvailability)
		values (
			:dayOfWeek,
			:startA,
			:endA
		)
	");
	q.addParam(name="dayOfWeek",value=aStartTime,cfsqltype="cf_sql_integer");
	q.addParam(name="startA",value=aStartTime,cfsqltype="cf_sql_timestamp");
	q.addParam(name="endA",value=aEndTime,cfsqltype="cf_sql_timestamp");
	q = q.execute().getResult();
	*/

	calendarDAO = createObject("component","dl.comp.org.secord.date_locker.CalendarDAO");

	calendarDAO.businessHoursSet(dayOfWeek(variables.days.Day1.calDate),variables.days.Day1.BusinessHours);
	calendarDAO.appointmentAvailabilityBlockCreate(
		dateFormat(variables.days.Day1.calDate,"yyyy-mm-dd") & " " &
		listFirst(variables.days.Day1.AvailabilityHours),
		dateFormat(variables.days.Day1.calDate,"yyyy-mm-dd") & " " &
		listLast(variables.days.Day1.AvailabilityHours),
		true
	);

	calendarDAO.businessHoursSet(dayOfWeek(variables.days.Day2.calDate),variables.days.Day2.BusinessHours);
	calendarDAO.appointmentAvailabilityBlockCreate(
		dateFormat(variables.days.Day2.calDate,"yyyy-mm-dd") & " " &
		listFirst(variables.days.Day2.AvailabilityHours),
		dateFormat(variables.days.Day2.calDate,"yyyy-mm-dd") & " " &
		listLast(variables.days.Day2.AvailabilityHours),
		true
	);

	calendarDAO.businessHoursSet(dayOfWeek(variables.days.Day3.calDate),variables.days.Day3.BusinessHours);
	calendarDAO.appointmentAvailabilityBlockCreate(
		dateFormat(variables.days.Day3.calDate,"yyyy-mm-dd") & " " &
		listFirst(variables.days.Day3.AvailabilityHours),
		dateFormat(variables.days.Day3.calDate,"yyyy-mm-dd") & " " &
		listLast(variables.days.Day3.AvailabilityHours),
		true
	);

	// existing appointment 1
	var sTime = dateFormat(variables.days.Day3.calDate,"yyyy-mm-dd")&" "&listFirst(variables.days.Day3.ExistingAppointment1);
	var eTime = dateFormat(variables.days.Day3.calDate,"yyyy-mm-dd")&" "&listLast(variables.days.Day3.ExistingAppointment1);
	var q = new Query();
	q.setDataSource("dl");
	q.setSQL("
		insert into dl_client (emailAddress,passwd)
		values ('1','1')
	");
	q.execute();
	q.setSQL("
		insert into dl_appointment (clientID,startTime,endTime)
		select clientID,'#sTime#','#eTime#'
		from dl_client
	");
	q.execute();

	// existing appointment 2
	sTime = dateFormat(variables.days.Day3.calDate,"yyyy-mm-dd")&" "&listFirst(variables.days.Day3.ExistingAppointment2);
	eTime = dateFormat(variables.days.Day3.calDate,"yyyy-mm-dd")&" "&listLast(variables.days.Day3.ExistingAppointment2);
	q.setSQL("
		insert into dl_appointment (clientID,startTime,endTime)
		select clientID,'#sTime#','#eTime#'
		from dl_client
	");
	q.execute();



}
/**
 * this prevents _SP's setup function from running before each test. If it runs, the existing appointments and business
 * hours would be deleted, and some tests would fail
 */
public void function setup() {}

/**
 * loops through a string containing appointment data and expected isAvailable SP results
 * 	var appointmentData = "
 *	A1	8:00-8:30	0	0	0
 *	A2	8:00-9:00	0	0	0
 *	A3	8:30-9:30	0	0	0
 * ";
 *
 * creates a structure that is read by the private doAssert method when each test is run
 */
private struct function prepareAsserts (required string appointmentData) {
	var CRLF = chr(13) & chr(10);
	var TAB = chr(9);

	var tmp = structNew();

	while (listLen(appointmentData,CRLF)) {

		// pop first appointment off the appointment data string
		var cAppt = listFirst(appointmentData,CRLF);
		appointmentData = listRest(appointmentData,CRLF);

		if (listLen(cAppt,TAB)) {

			var appointmentID = listFirst(cAppt,TAB);
			var appointmentTime = listGetAt(cAppt,2,TAB);

			tmp[appointmentID] = structNew();

			tmp[appointmentID].startTime = listFirst(listFirst(appointmentTime,"-"));
			tmp[appointmentID].endTime = listFirst(listRest(appointmentTime,"-"));

			tmp[appointmentID].day1 = listGetAt(cAppt,3,TAB);
			tmp[appointmentID].day2 = listGetAt(cAppt,4,TAB);
			tmp[appointmentID].day3 = listGetAt(cAppt,5,TAB);
		}

	}

	return tmp;
}

/**
 * performs an MXUnit assertion for one dayID and one appointmentID
 */
private void function doAssert(dayID,appointmentID) {
	var startTime = dateFormat(variables.days[dayID].calDate,"yyyy-mm-dd") &" "& variables.appointments[appointmentID].startTime;
	var endTime = dateFormat(variables.days[dayID].calDate,"yyyy-mm-dd") &" "& variables.appointments[appointmentID].endTime;

	if (variables.appointments[appointmentID][dayID]) {
		assertTrue(isAvailable(startTime,endTime),isAvailableReason(startTime,endTime));
	} else {
		assertFalse(isAvailable(startTime,endTime),"appointment should not be available");
	}
}

/**
 * an abstraction of the SP that this test suite tests
 */
private boolean function isAvailable(aStartTime,aEndTime) {

	var q = new Query();
	q.setDataSource("dl");
	q.setSQL("
		select dl_isAvailable(
			:aStartTime,
			:aEndTime
		) as availability
	");
	q.addParam(name="aStartTime",value=aStartTime,cfsqltype="cf_sql_timestamp");
	q.addParam(name="aEndTime",value=aEndTime,cfsqltype="cf_sql_timestamp");
	q = q.execute().getResult();

	return q.availability;
}

/**
 * in addtion to the isAvailable() function, there's a function that returns a string reason
 * why the appointment time is not available. This function's output is used by the doAssert
 * method to show a human-readable failure reason, to aid in troubleshooting
 */
private string function isAvailableReason(aStartTime,aEndTime) {

	var q = new Query();
	q.setDataSource("dl");
	q.setSQL("
		select dl_isAvailableReason(
			:aStartTime,
			:aEndTime
		) as availability
	");
	q.addParam(name="aStartTime",value=aStartTime,cfsqltype="cf_sql_timestamp");
	q.addParam(name="aEndTime",value=aEndTime,cfsqltype="cf_sql_timestamp");
	q = q.execute().getResult();


	return "isAvailable(" & aStartTime & "," & aEndTime & ")=" & q.availability;
}

/*
 * These are the actual tests. As you can see, thanks to the private methods above, these are just
 * calls to doAssert(), which looks up that day/appointmnet's information and performs the actual
 * test assertion
 */
public void function Day1_A01() { doAssert("Day1","A01");}
public void function Day1_A02() { doAssert("Day1","A02");}
public void function Day1_A03() { doAssert("Day1","A03");}
public void function Day1_A04() { doAssert("Day1","A04");}
public void function Day1_A05() { doAssert("Day1","A05");}
public void function Day1_A06() { doAssert("Day1","A06");}
public void function Day1_A07() { doAssert("Day1","A07");}
public void function Day1_A08() { doAssert("Day1","A08");}
public void function Day1_A09() { doAssert("Day1","A09");}
public void function Day1_A10() { doAssert("Day1","A10");}
public void function Day1_A11() { doAssert("Day1","A11");}
public void function Day1_A12() { doAssert("Day1","A12");}
public void function Day1_A13() { doAssert("Day1","A13");}
public void function Day1_A14() { doAssert("Day1","A14");}
public void function Day1_A15() { doAssert("Day1","A15");}
public void function Day1_A16() { doAssert("Day1","A16");}
public void function Day1_A17() { doAssert("Day1","A17");}
public void function Day1_A18() { doAssert("Day1","A18");}

public void function Day2_A01() { doAssert("Day2","A01");}
public void function Day2_A02() { doAssert("Day2","A02");}
public void function Day2_A03() { doAssert("Day2","A03");}
public void function Day2_A04() { doAssert("Day2","A04");}
public void function Day2_A05() { doAssert("Day2","A05");}
public void function Day2_A06() { doAssert("Day2","A06");}
public void function Day2_A07() { doAssert("Day2","A07");}
public void function Day2_A08() { doAssert("Day2","A08");}
public void function Day2_A09() { doAssert("Day2","A09");}
public void function Day2_A10() { doAssert("Day2","A10");}
public void function Day2_A11() { doAssert("Day2","A11");}
public void function Day2_A12() { doAssert("Day2","A12");}
public void function Day2_A13() { doAssert("Day2","A13");}
public void function Day2_A14() { doAssert("Day2","A14");}
public void function Day2_A15() { doAssert("Day2","A15");}
public void function Day2_A16() { doAssert("Day2","A16");}
public void function Day2_A17() { doAssert("Day2","A17");}
public void function Day2_A18() { doAssert("Day2","A18");}

public void function Day3_A01() { doAssert("Day3","A01");}
public void function Day3_A02() { doAssert("Day3","A02");}
public void function Day3_A03() { doAssert("Day3","A03");}
public void function Day3_A04() { doAssert("Day3","A04");}
public void function Day3_A05() { doAssert("Day3","A05");}
public void function Day3_A06() { doAssert("Day3","A06");}
public void function Day3_A07() { doAssert("Day3","A07");}
public void function Day3_A08() { doAssert("Day3","A08");}
public void function Day3_A09() { doAssert("Day3","A09");}
public void function Day3_A10() { doAssert("Day3","A10");}
public void function Day3_A11() { doAssert("Day3","A11");}
public void function Day3_A12() { doAssert("Day3","A12");}
public void function Day3_A13() { doAssert("Day3","A13");}
public void function Day3_A14() { doAssert("Day3","A14");}
public void function Day3_A15() { doAssert("Day3","A15");}
public void function Day3_A16() { doAssert("Day3","A16");}
public void function Day3_A17() { doAssert("Day3","A17");}
public void function Day3_A18() { doAssert("Day3","A18");}
}