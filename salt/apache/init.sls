apache2:
  pkg:
    - installed
  service:
    - running:
    - enable: True
    - reload: True
    - watch:
      - file: /etc/apache2/apache2.conf
    - require:
      - file: /etc/apache2/apache2.conf

/etc/apache2/apache2.conf:
  file.managed:
    - source: salt://apache/files/apache2.conf
    - require:
      - pkg: apache2
    - user: www-data
    - group: www-data
    - mode: 644




