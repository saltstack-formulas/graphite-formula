{%- if 'monitor' in salt['grains.get']('roles',[]) %}
{%- from 'graphite/settings.sls' import graphite with context %}

# putting this in here for now as it is closely related to graphite
# see if this will merit its own formula at some

process-dirs:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - names:
      - /var/log/diamond
      - /var/run/diamond

/tmp/diamond_reqs.txt:
  file.managed:
    - source: salt://graphite/files/diamond_reqs.txt
    - template: jinja

pip-install-diamond:
  cmd.wait:
    - env:
      - VIRTUAL_ENV: 'fix-the-diamond-installer-on-CentOS'
    - name: pip install --upgrade -r /tmp/diamond_reqs.txt
    - watch:
      - file: /tmp/diamond_reqs.txt

/etc/diamond/diamond.conf:
  file.managed:
    - source: salt://graphite/files/diamond/diamond.conf
    - mode: 644
    - template: jinja
    - require:
      - cmd: pip-install-diamond

/etc/diamond/handlers/GraphiteHandler.conf:
  file.managed:
    - source: salt://graphite/files/diamond/handlers/GraphiteHandler.conf
    - mode: 644
    - template: jinja
    - makedirs: True
    - context:
      graphite_host: {{ graphite.host }}
      graphite_port: {{ graphite.port }}
      graphite_pickle_port: {{ graphite.pickle_port }}
    - require:
      - cmd: pip-install-diamond

/etc/diamond/handlers/GraphitePickleHandler.conf:
  file.managed:
    - source: salt://graphite/files/diamond/handlers/GraphitePickleHandler.conf
    - mode: 644
    - template: jinja
    - makedirs: True
    - context:
      graphite_host: {{ graphite.host }}
      graphite_port: {{ graphite.port }}
      graphite_pickle_port: {{ graphite.pickle_port }}
    - require:
      - cmd: pip-install-diamond

/etc/init.d/diamond:
  file.managed:
    - source: salt://graphite/files/diamond.init
    - mode: 755
    - template: jinja

rename-dist-collectors:
  cmd.run:
    - name: mv /etc/diamond/collectors /etc/diamond/collectors.dist
    - unless: test -L /etc/diamond/collectors
    - onlyif: test -d /etc/diamond/collectors

/etc/diamond/collectors.salt:
  file.recurse:
    - source: salt://graphite/files/diamond/collectors

/etc/diamond/collectors:
  file.symlink:
    - target: /etc/diamond/collectors.salt

diamond:
  service.running:
    - enable: True
    - watch:
      - file: /etc/diamond/diamond.conf
      - file: /etc/diamond/collectors.salt
      - file: /etc/diamond/handlers/GraphiteHandler.conf
      - file: /etc/diamond/handlers/GraphitePickleHandler.conf

{%- endif %}
