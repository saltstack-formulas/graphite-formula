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

{%- set admin_email    = gc.get('admin_email', pc.get('admin_email', 'admin@example.com')) %}
{%- set admin_user     = gc.get('admin_user', pc.get('admin_user', 'admin')) %}

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
                          'dbuser'         : 'graphite',
                          'dbpassword'     : 'graphite',
                          'dbname'         : 'graphite',
                          'dbtype'         : 'mysql',
                          'admin_email'    : admin_email,
                          'admin_user'     : admin_user,
                          'admin_password' : admin_password,
                        }) %}
