# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_package_install = tplroot ~ '.package.install' %}
{%- from tplroot ~ "/map.jinja" import mapdata as nosql_booster with context %}

{%- set common_key_path = 'C:\\Users\\Default\\AppData\\Roaming\\' ~
      'NoSQLBooster for MongoDB\\license.key'
%}

include:
  - {{ sls_package_install }}

{%- if nosql_booster.config.get('license_string') %}
Install Pillar-Supplied License-String:
  file.managed:
    - contents: '{{ nosql_booster.config.license_string }}'
    - group: 'Administrators'
    - makedirs: True
    - name: '{{ common_key_path }}'
    - require:
      - cmd: 'Install NoSQL Booster'
    - user: 'Administrators'
{%- endif %}

NoSQL Booster Desktop Shortcut:
  shortcut.present:
    - icon_location: '{{ nosql_booster.config.install_root }}\NoSQLBooster for MongoDB.exe'
    - name: 'C:\Users\Public\Desktop\NoSQLBooster for MongoDB.lnk'
    - require:
      - cmd: 'Install NoSQL Booster'
    - target: '{{ nosql_booster.config.install_root }}\NoSQLBooster for MongoDB.exe'
    - working_dir: '{{ nosql_booster.config.install_root }}'

NoSQL Booster Start Menu Shortcut:
  shortcut.present:
    - icon_location: '{{ nosql_booster.config.install_root }}\NoSQLBooster for MongoDB.exe'
    - name: 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\NoSQLBooster for MongoDB.lnk'
    - require:
      - cmd: 'Install NoSQL Booster'
      - shortcut: 'NoSQL Booster Desktop Shortcut'
    - target: '{{ nosql_booster.config.install_root }}\NoSQLBooster for MongoDB.exe'
    - working_dir: '{{ nosql_booster.config.install_root }}'

NoSQL Booster System Path Update:
  win_path.exists:
    - name: '{{ nosql_booster.config.install_root }}'
    - require:
      - cmd: 'Install NoSQL Booster'
      - shortcut: 'NoSQL Booster Start Menu Shortcut'
