========
graphite
========

Formula to set up and configure graphite servers on Debian and RedHat systems

Set `monitor_master` role grain on the minion you want graphite installed on:

    salt 'graphitemaster' grains.append roles monitor_master

.. note::

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

Starting Service
================

Setup database if not already done ::

    python /opt/graphite/webapp/graphite/manage.py syncdb

Start graphite ::

    /opt/graphite/bin/run-graphite-devel-server.py /opt/graphite &

Generating a new password
==========================

Uses the `Passlib library <http://pythonhosted.org/passlib/>`_ ::

    pip install passlib
    
Then make::

    python -c "from passlib.hash import pbkdf2_sha256; import getpass, pwd; print pbkdf2_sha256.encrypt(getpass.getpass())"
    Password: [ENTER YOUR PASSWORD HERE]


Available states
================

.. contents::
    :local:

``graphite``
------------

Installs all dependencies and the graphite packages themselves, sets up a minimal system including 
supervisor to run carbon and django and nginx as the proxy.

``graphite.supervisor``
-----------------------

Adds a basic supervisor configuration for the graphite daemons to work on top of.
The graphite state already depends on this one internally - eventually there should be a supervisor-formula.

``graphite.mysqldb``
--------------------

Depends on the mysql-formula's mysql.client and mysql.server, makes the graphite server use mysql
for the admin login.

Please note that this is a very basic (and monolithic) formula, not necessarily intended for production use.
