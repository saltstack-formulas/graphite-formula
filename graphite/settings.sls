{%- set host = salt['mine.get']('roles:monitor_master', 'network.interfaces', 'grain').keys()|first() %}

{%- if host is not defined %}
{%- set host = 'graphite' %}
{%- endif %}

# make this configurable if needed
{%- set port = '2003' %}
{%- set pickle_port = '2004' %}

{%- set graphite = {} %}
{%- do graphite.update( {
                          'host' : host,
                          'port' : port,
                          'pickle_port': pickle_port
                        }) %}
