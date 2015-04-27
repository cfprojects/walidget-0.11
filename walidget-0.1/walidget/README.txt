Walidget: A better Widget example for Model-Glue


Walidget is a fork of the Widget example application included in Model-Glue:ColdFusion 2.0.304 (the current stable version at the time of this release).

The goal of Walidget is to offer a better starting point for ColdFusion developers to get into the Model-Glue, ColdSpring, and Transfer ORM frameworks. This is achieved by implementing small but real feature enhancements that demonstrate the power of these frameworks.

Some key enhancements already made in Walidget are:

* Better support for nullable database columns;
* Logging of application events to either a cflog or a database table;
* Automatic support for "Date Last Updated" database columns;
* Richer form validation support.

The improvements in form validation is especially noteworthy as the form validation support included in Model-Glue is quite basic when the Transfer ORM is used. Walidget uses the Validat validation engine from Alagad, Inc. to provide a much richer validation feature set that is independent of the ORM being used, while still being compatible with Model-Glue's scaffolding feature.

A copy of Validat is included in the Walidget application. Also included are some useful custom validator addons for Validat.


REQUIREMENTS:

Walidget was developed in ColdFusion 8 but is expected to work in ColdFusion 7 as well. The following frameworks must be installed:

* Model-Glue:ColdFusion (version 2.0.304).
* ColdSpring (version 1.2 or later).
* Transfer (version 1.1 or later).

While the original Widget example application came in Reactor and Transfer ORM flavours, Walidget supports the Transfer ORM only.


Find any bugs or have any comments about this project?  Please visit the project home page at http://walidget.riaforge.org/.

Cheers,

Dennis Clark

