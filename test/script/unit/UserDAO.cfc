component extends="_unit" {

/**
 * tests userDAO.clientCreate()
 */
public void function clientCreate() {
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
}

/**
 * tests userDAO.clientExists()
 */
public void function clientExists() {

	assertFalse(userDAO.clientExists("invalid@email.com"),"nonexistant client is nonexistant");

	var client1Email = "client1@email.com";
	var client1Passwd = "passwd";
	this.createClient(client1Email,client1Passwd);

	assertTrue(userDAO.clientExists(client1Email),"existant client existx");
}

/**
 * tests userDAO.clientGet()
 */
public void function clientGet() {


	// invalid client (there can never be a clientID = 0), returns zero rows
	var q = userDAO.clientGet(0);
	assertFalse(q.recordCount,"client not found");

	// create a valid client
	var client1Email = "client1@email.com";
	var client1Passwd = "passwd";
	var client1ID = this.createClient(client1Email,client1Passwd);

	// valid client, returns a single row with client info
	var q = userDAO.clientGet(client1ID);
	assertTrue(q.recordCount,"client found");

}

/**
 * tests userDAO.clientUpdate()
 */
public void function clientUpdate() {
	assertTrue(false,"this test has not yet been coded");
}

}