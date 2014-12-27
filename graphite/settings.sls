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

# settings relevant to graphite server performance
{%- set max_updates_per_second = gc.get('max_updates_per_second', pc.get('max_updates_per_second', '500')) %}
{%- set max_creates_per_minute = gc.get('max_creates_per_minute', pc.get('max_creates_per_minute', '50')) %}

# the writing to the whisper files will quickly kill access times to any disk - put it elsewhere if you can
{%- set whisper_dir    = gc.get('whisper_dir', pc.get('whisper_dir', '/opt/graphite/storage/whisper')) %}

# default supervisor init file
# filename must NOT be "supervisord.conf"
{%- set supervisor_init = gc.get('supervisor_init', pc.get('supervisor_init', '/etc/init.d/supervisor')) %}
{%- set supervisor_init_name = supervisor_init.split('/')|last() %}

# default supervisor config file
# filename should be: "supervisord.conf" 
# as specified in the defaults: http://supervisord.org/configuration.html
{%- set supervisor_conf = gc.get('supervisor_conf', pc.get('supervisor_conf', '/etc/supervisord.conf')) %}

# the only supported alternative here is mysql as dbtype
{%- set dbtype         = gc.get('dbtype', pc.get('dbtype', 'sqlite3')) %}
{%- set dbname         = gc.get('dbname', pc.get('dbname', '/opt/graphite/storage/graphite.db')) %}
{%- set dbuser         = gc.get('dbuser', pc.get('dbuser', '')) %}
{%- set dbpassword     = gc.get('dbpassword', pc.get('dbpassword', '')) %}
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
                          'max_updates_per_second': max_updates_per_second,
                          'max_creates_per_minute': max_creates_per_minute,
                          'dbuser'         : dbuser,
                          'dbpassword'     : dbpassword,
                          'dbname'         : dbname,
                          'dbtype'         : dbtype,
                          'dbhost'         : dbhost,
                          'dbport'         : dbport,
                          'admin_email'    : admin_email,
                          'admin_user'     : admin_user,
                          'admin_password' : admin_password,
                          'whisper_dir'    : whisper_dir,
                          'supervisor_init': supervisor_init,
                          'supervisor_init_name': supervisor_init_name,
                          'supervisor_conf': supervisor_conf
                        }) %}
