# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as nosql_booster with context %}

{#- Define paths using double-backslashes and 80-column-safe breaks -#}
{%- set install_root = nosql_booster.config.install_root %}
{%- set junction = 'C:\\nosql_uninstall_temp' %}
{%- set reg_key = 'HKEY_USERS\\S-1-5-18\\Software\\Microsoft\\Windows\\' ~
                  'CurrentVersion\\Uninstall\\' ~ nosql_booster.pkg.reg_guid
%}
{%- set uninstaller = junction ~ '\\Uninstall NoSQLBooster for MongoDB.exe' %}

Cleanup Uninstallation Junction:
  cmd.run:
    - name: 'ping -n 5 127.0.0.1 >nul & rmdir {{ junction }}'
    - onlyif: 'test-path {{ junction }}'
    - require:
      - cmd: 'Run NoSQL Booster Uninstaller'
    - shell: powershell

Create Uninstallation Junction:
  cmd.run:
    - name: 'mklink /J {{ junction }} "{{ install_root }}"'
    - onlyif: 'test-path "{{ install_root }}"'
    - require:
      - cmd: 'Kill Running NoSQL Booster Instances'
    - shell: powershell

Final Scorched Earth Cleanup:
  file.absent:
    - names:
      - '{{ install_root }}'
      - '{{ nosql_booster.pkg.download_save_dir }}\\nosqlbooster-setup.exe'
    - require:
      - cmd: 'Cleanup Uninstallation Junction'

Kill Running NoSQL Booster Instances:
  cmd.run:
    - name: 'taskkill /F /IM "NoSQLBooster for MongoDB.exe" /T || exit 0'
    - shell: powershell

NoSQL Booster Registry Removal:
  reg.absent:
    - name: '{{ reg_key }}'
    - require:
      - file: 'Final Scorched Earth Cleanup'

Run NoSQL Booster Uninstaller:
  cmd.run:
    - name: 'start /wait "" "{{ uninstaller }}" /S /allusers'
    - onlyif: 'test-path "{{ uninstaller }}"'
    - require:
      - cmd: 'Create Uninstallation Junction'
