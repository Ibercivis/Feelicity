This file is for you to describe the tedx application. Typically
you would include information such as the information below:

Installation and Setup
======================

Install ``tedx`` using easy_install::

    easy_install tedx

Make a config file as follows::

    paster make-config tedx config.ini

Tweak the config file as appropriate and then setup the application::

    paster setup-app config.ini

Then you are ready to go.

Libraries
=========
La librería de geocoding que se utiliza (geopy) no puede hacer reverse geocoding por defecto. Para solucionar esto, se utiliza una versión especial de la misma descrita en la siguiente página: http://code.google.com/p/geopy/wiki/ReverseGeocoding.
