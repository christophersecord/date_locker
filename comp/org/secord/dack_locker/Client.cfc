/** represents a single client that is able to log in and schedule appointments
 * @author christophersecord
 * @date 20140124
 * @language ColdFusion
 * @platform Lucee
 */
component {

	variables.DAO = new UserDAO();

	variables.clientID = 0;
	variables.email = "";


	/**
	 * constructor. Populates properties by looking up the clientID.
	 */
	public User function init (required number clientID) {
		return this;
	}

	/**
	 * alternate constructor when creating a new client
	 */
	public User function newUser (
		required string emailAddress,
		required string plaintextPassword
	) {

		var newClientID = 0;

		// if the email address doesn't already exist

			// create the client record

		// return the newly created client
		return new User(newClientID);
	}

	/**
	 * a web service for determining if the email address is available
	 */
	remote boolean function emailExists (required string emailAddress) {
		return DAO.clientExists(emailAddress);
	}

	/**
	 * getter for email address
	 */
	public string function getEmail() { return variables.email; }

	/**
	 * setter for email address
	 */
	public boolean function setEmail (required string emailAddress) {
		if (this.emailExists(emailAddress)) {
			return false;
		} else {
			variables.email = emailAddress;
			return true;
		}
	}

	// TODO: setter for password
	// TODO: "save" method, calls clientUpdate to write set values
}