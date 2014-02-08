component extends="_unit" {

/**
 * tests clientDAO.clientCreate()
 */
public void function clientCreate() {
	var client1Email = "client1@email.com";
	var client1Passwd = "passwd";

	// client 1 doesn't exist
	assertFalse(clientDAO.clientExists(client1Email),"client1 doesn't exist");

	// create client 1
	var client1ID = clientDAO.clientCreate(client1Email,client1Passwd);

	// a valid clientID is returned
	assert(isNumeric(client1ID) && client1ID > 0,"client1 created successfully");

	// client 1 now exists
	assertTrue(clientDAO.clientExists(client1Email),"client1 now exists");
}

/**
 * tests clientDAO.clientExists()
 */
public void function clientExists() {

	assertFalse(clientDAO.clientExists("invalid@email.com"),"nonexistant client is nonexistant");

	var client1Email = "client1@email.com";
	var client1Passwd = "passwd";
	this.createClient(client1Email,client1Passwd);

	assertTrue(clientDAO.clientExists(client1Email),"existant client existx");
}

/**
 * tests clientDAO.clientGet()
 */
public void function clientGet() {


	// invalid client (there can never be a clientID = 0), returns zero rows
	var q = clientDAO.clientGet(0);
	assertFalse(q.recordCount,"client not found");

	// create a valid client
	var client1Email = "client1@email.com";
	var client1Passwd = "passwd";
	var client1ID = this.createClient(client1Email,client1Passwd);

	// valid client, returns a single row with client info
	var q = clientDAO.clientGet(client1ID);
	assertTrue(q.recordCount,"client found");

}

/**
 * tests clientDAO.clientUpdate()
 */
public void function clientUpdate() {
	assertTrue(false,"this test has not yet been coded");
}

}