This is a modified version of the Validat validation engine from Alagad, Inc.

More information on Validat:

	Project Home: http://www.alagad.com/go/products-and-projects/validat-data-validation-engine
	Trac Site: http://trac.alagad.com/Validat

The original source was downloaded from the following URL:

	http://trac.alagad.com/Validat/changeset/50/trunk/src?old_path=%2F&format=zip

The following changes have been applied to this copy of Validat:

1. In validat.cfc, the parseConfigXML method was changed from access="private" to access="package".
2. The validatFactory.cfc component was added.
