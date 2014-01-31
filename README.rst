========
graphite
========

Formula to set up and configure graphite servers on Debian and RedHat systems

.. note::

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/topics/conventions/formulas.html>`_.

Available states
================

.. contents::
    :local:

``graphite``
-------

Installs all dependencies and the graphite packages themselves, sets up a minimal system including 
supervisor to run carbon and django and nginx as the proxy.

Please note that this is a very basic (and monolithic) formula, not necessarily intended for production use.
