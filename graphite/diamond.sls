{%- if 'monitor' in salt['grains.get']('roles',[]) %}

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

python-pip:
  pkg.installed

pip-install-diamond:
  pip.installed:
    - names:
      - psutil
      - ConfigObj
      - diamond
    - require:
      - pkg: python-pip

/etc/diamond/diamond.conf:
  file.managed:
    - source: salt://graphite/files/diamond/diamond.conf
    - mode: 644
    - template: jinja
    - context:
      graphite_host: {{ salt['grains.get']('graphite_host', 'monitor') }}
    - require:
      - pip: pip-install-diamond

/etc/init.d/diamond:
  file.managed:
    - source: salt://graphite/files/diamond.init
    - mode: 755
    - template: jinja

rename-dist-collectors:
  cmd.run:
    - name: mv /etc/diamond/collectors /etc/diamond/collectors.dist
    - unless: test -L /etc/diamond/collectors

/etc/diamond/collectors.salt:
  file.recurse:
    - source: salt://graphite/files/diamond/collectors

/etc/diamond/collectors:
  file.symlink:
    - target: /etc/diamond/collectors.salt

diamond:
  service.running:
    - enable: True
    - reload: True
    - watch:
      - file: /etc/diamond/diamond.conf
      - file: /etc/diamond/collectors.salt

{%- endif %}
