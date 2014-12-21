config-dir:
  file.directory:
    - names:
      - /etc/supervisor/conf.d
      - /var/log/supervisor
    - user: root
    - group: root
    - mode: 755
    - makedirs: True

supervisor:
  pip.installed

# supervisorctl picks up /etc/init/supervisord.conf and attempts to use it as a supervisor configuration file
# instead we want /etc/init/supervisor.conf -- which will strictly be used as an upstart file
# via: http://cuppster.com/2011/05/18/using-supervisor-with-upstart/
/etc/init/supervisor.conf:
  file.managed:
    - mode: 644
    - contents: |
        [supervisord]
        nodaemon=false
        logfile=/var/log/supervisor/supervisord.log
        pidfile=/var/run/supervisord.pid
        childlogdir=/var/log/supervisor

        [include]
        files = /etc/supervisor/conf.d/*.conf

        [rpcinterface:supervisor]
        supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface

        [supervisorctl]
        serverurl=unix:///var/run//supervisor.sock


/etc/init.d/supervisord:
  file.managed:
    - source: salt://graphite/files/supervisor/supervisor.init
    - mode: 755
    - template: jinja

supervisor-service:
  service:
{%- if grains['os_family'] == 'Debian' %}
    - name: supervisor
{%- elif grains['os_family'] == 'RedHat' %}
    - name: supervisord
{%- endif %}
    - running
    - reload: True
    - enable: True
    - watch:
      - pip: supervisor
      - file: /etc/init/supervisor.conf
