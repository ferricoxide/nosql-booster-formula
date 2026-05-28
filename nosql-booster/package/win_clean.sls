# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as nosql_booster with context %}

{#- Define paths using double-backslashes and 80-column-safe breaks -#}
{%- set install_root = nosql_booster.config.install_root %}
{%- set installer_exe = nosql_booster.pkg.download_save_dir ~ '\\nosqlbooster-setup.exe' %}
{%- set junction = 'C:\\nosql_install_temp' %}
{%- set reg_key = 'HKEY_USERS\\S-1-5-18\\Software\\Microsoft\\Windows\\' ~
                  'CurrentVersion\\Uninstall\\' ~ nosql_booster.pkg.reg_guid
%}
{%- set uninstaller = junction ~ '\\Uninstall NoSQLBooster for MongoDB.exe' %}

Cleanup Uninstallation Junction:
  cmd.run:
    - name: 'Start-Sleep -Seconds 5; if (Test-Path "{{ junction }}") { Remove-Item -Path "{{ junction }}" -Force }'
    - onlyif: 'Test-Path "{{ junction }}"'
    - require:
      - cmd: 'Run NoSQL Booster Uninstaller'
    - shell: powershell

Create Uninstallation Junction:
  cmd.run:
    - name: 'New-Item -ItemType Junction -Path "{{ junction }}" -Value "{{ install_root }}"'
    - onlyif: 'Test-Path "{{ install_root }}"'
    - require:
      - cmd: 'Kill Running NoSQL Booster Instances'
    - shell: powershell

Final Scorched Earth Cleanup:
  file.absent:
    - names:
      - '{{ install_root }}'
      - '{{ installer_exe }}'
    - require:
      - cmd: 'Cleanup Uninstallation Junction'

Kill Running NoSQL Booster Instances:
  cmd.run:
    - name: 'taskkill /F /IM "NoSQLBooster for MongoDB.exe" /T; exit 0'
    - shell: powershell

NoSQL Booster Registry Removal:
  reg.absent:
    - name: '{{ reg_key }}'
    - require:
      - file: 'Final Scorched Earth Cleanup'

Run NoSQL Booster Uninstaller:
  cmd.run:
    - name: 'Start-Process -FilePath "{{ uninstaller }}" -ArgumentList "/S", "/allusers" -Wait'
    - onlyif: 'Test-Path "{{ uninstaller }}"'
    - require:
      - cmd: 'Create Uninstallation Junction'
    - shell: powershell
