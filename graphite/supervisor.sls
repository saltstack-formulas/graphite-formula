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

{% if salt.grains.get('os_family') == 'Debian' %}
supervisor:
  pkg.installed:
    - require:
      - pkg: install-deps
{% else %}
supervisor:
  pip.installed:
    - require:
      - pkg: install-deps

{{ graphite.supervisor_init }}:
  file.managed:
    - source: salt://graphite/files/supervisor/supervisor.init
    - mode: 755
    - template: jinja

{% endif %}

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

supervisor-service:
  service:
    - name: {{ graphite.supervisor_init_name }}
    - running
    - reload: True
    - enable: True
    - watch:
      {%- if salt.grains.get('os_family') == 'Debian' %}
      - pkg: supervisor
      {%- else %}
      - pip: supervisor
      {%- endif %}
      - file: {{ graphite.supervisor_conf }}

