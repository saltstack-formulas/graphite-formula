{% set p  = salt['pillar.get']('graphite', {}) %}
{% set pc = p.get('config', {}) %}
{% set g  = salt['grains.get']('graphite', {}) %}
{% set gc = g.get('config', {}) %}

{%- set host = salt['mine.get']('roles:monitor_master', 'network.interfaces', 'grain').keys()|first() %}

{%- if host is not defined %}
{%- set host = 'graphite' %}
{%- endif %}

# make this configurable if needed
{%- set port = gc.get('port', pc.get('port', '2003')) %}
{%- set pickle_port = gc.get('pickle_port', pc.get('pickle_port', '2004')) %}

# the only supported alternative here is mysql as dbtype
{%- set dbtype         = gc.get('dbtype', pc.get('dbtype', 'sqlite3')) %}
{%- set dbname         = gc.get('dbname', pc.get('dbname', '/opt/graphite/storage/graphite.db')) %}
{%- set dbuser         = gc.get('dbuser', pc.get('dbuser', '')) %}
{%- set dbpassword         = gc.get('dbpassword', pc.get('dbpassword', '')) %}
{%- set dbhost         = gc.get('dbhost', pc.get('dbhost', '')) %}
{%- set dbport         = gc.get('dbport', pc.get('dbport', '')) %}

# default username and password are admin
{%- set default_password = 'pbkdf2_sha256$10000$wZuRMciV2VKr$OAtsP+BksbR2DPQUEsY728cbIJmuYf4uXg4tLLGsvi4=' %}
{%- set admin_password = gc.get('admin_password', pc.get('admin_password', default_password)) %}
{%- set admin_user     = gc.get('admin_user', pc.get('admin_user', 'admin')) %}
{%- set admin_email    = gc.get('admin_email', pc.get('admin_email', 'graphite@example.com' )) %}

{%- set graphite = {} %}
{%- do graphite.update( {
                          'prefix'         : '/opt/graphite',
                          'host'           : host,
                          'port'           : port,
                          'pickle_port'    : pickle_port,
                          'dbuser'         : dbuser,
                          'dbpassword'     : dbpassword,
                          'dbname'         : dbname,
                          'dbtype'         : dbtype,
                          'dbhost'         : dbhost,
                          'dbport'         : dbport,
                          'admin_email'    : admin_email,
                          'admin_user'     : admin_user,
                          'admin_password' : admin_password,
                        }) %}
