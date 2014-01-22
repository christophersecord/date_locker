/**
 * for those tests that use railo, sets up the server environment such as the path to frameworks
 * individual tests are run sort of like this (on my machine anyway):
 * http://localhost/dl/test/script/sp/clientcreate.cfc?method=runtestremote
 */
component {
	this.name="unittests";
	
	setting enablecfoutputonly="false";

	// components to be tested
	this.mappings["comp"] = "dl.comp";

	// the coldfusion MXUnit framework (not sure why the dot notation doesn't work for this mapping)
	this.mappings["mxunit"] = "/dl/test/framework/mxunit";

	mxunit_root = "/dl/test/framework/mxunit";

}