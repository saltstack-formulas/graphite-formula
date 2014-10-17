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

/etc/supervisord.conf:
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
{%- if grains['os_family'] == 'Debian' %}
    - source: salt://graphite/files/supervisor/supervisor.init.debian
{%- elif grains['os_family'] == 'RedHat' %}
    - source: salt://graphite/files/supervisor/supervisor.init
{%- endif %}
    - mode: 755
    - template: jinja

supervisor-service:
  service:
    - name: supervisord
    - running
    - reload: True
    - enable: True
    - watch:
      - pip: supervisor
      - file: /etc/supervisord.conf
