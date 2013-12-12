# putting this in here for now as it is closely related to graphite
# see if this will merit its own formula at some

python-pip:
  pkg.installed

diamond:
  pip.installed:
    - require:
      - pkg: python-pip

/etc/diamond/diamond.conf:
  file.managed:
    - source: salt://graphite/files/diamond.conf
    - mode: 644
    - template: jinja
