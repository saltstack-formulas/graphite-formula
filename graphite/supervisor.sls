{%- from 'graphite/settings.sls' import graphite with context %}

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
  pip.installed:
    - require:
      - pkg: install-deps

{{ graphite.supervisor_conf }}:
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

{{ graphite.supervisor_init }}:
  file.managed:
    - source: salt://graphite/files/supervisor/supervisor.init
    - mode: 755
    - template: jinja

supervisor-service:
  service:
    - name: {{ graphite.supervisor_init_name }}
    - running
    - reload: True
    - enable: True
    - watch:
      - pip: supervisor
      - file: {{ graphite.supervisor_conf }}
