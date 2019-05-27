ssh:
  pkg.installed:
    - name: openssh-server

/etc/ssh/sshd_config:
  file.managed:
    - source: salt://ssh/files/sshd_config
    - require:
      - pkg: ssh-server

ssh-service:
  service.running:
    - enable: True
    - watch:
      - file: sshd_config



