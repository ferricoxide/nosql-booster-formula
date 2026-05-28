# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as nosql_booster with context %}

{#- Use double-backslashes to prevent \U and \n escape sequence errors -#}
{%- set common_key_path = 'C:\\Users\\Default\\AppData\\Roaming' ~
     '\\NoSQLBooster for MongoDB\\license.key'
%}

NoSQL Booster Desktop Shortcut Removal:
  file.absent:
    - name: 'C:\Users\Public\Desktop\NoSQLBooster for MongoDB.lnk'

NoSQL Booster License Key Removal (Default User):
  file.absent:
    - name: '{{ common_key_path }}'

NoSQL Booster Start Menu Shortcut Removal:
  file.absent:
    - name: 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\NoSQLBooster for MongoDB.lnk'

NoSQL Booster System Path Removal:
  win_path.absent:
    - name: '{{ nosql_booster.config.install_root }}'
