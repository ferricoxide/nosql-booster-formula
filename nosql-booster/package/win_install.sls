# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as nosql_booster with context %}

{%- set installer_exe = nosql_booster.pkg.download_save_dir ~
    '\\nosqlbooster-setup.exe'
%}
{%- set junction = 'C:\\nosql_install_temp' %}
{%- set reg_key = 'HKEY_USERS\\S-1-5-18\\Software\\Microsoft\\Windows\\CurrentVersion' ~
    '\\Uninstall\\' ~ nosql_booster.pkg.reg_guid
%}

{%- if not nosql_booster.pkg.download_uri %}
NoSQL Booster download URL is missing:
  test.fail_without_changes:
    - comment: |
{{ nosql_booster.pkg.download_uri_error | indent(8, True) }}
    - name: "CRITICAL: 'nosql_booster:pkg:download_uri' is not defined."

{%- elif not nosql_booster.pkg.reg_guid %}
NoSQL Booster registry GUID is missing:
  test.fail_without_changes:
    - comment: |
        --------------------------------------------------
        The 'nosql_booster:pkg:reg_guid' is not defined in
        Pillar. This GUID (ProductCode) is required on
        Windows to perform registry corrections and ensure
        uninstaller functionality.
        --------------------------------------------------
    - name: "CRITICAL: Registry ProductCode GUID is not defined."

{%- else %}
Avoid being a null-router (package/win_install) - NoSQL Booster:
  test.nop: []

Cleanup Installation Junction:
  cmd.run:
    - name: 'ping -n 10 127.0.0.1 >nul & rmdir {{ junction }}'
    - onchanges:
      - cmd: 'Install NoSQL Booster'
    - require:
      - reg: 'Correct NoSQL Booster Registry - InstallLocation'
      - reg: 'Correct NoSQL Booster Registry - UninstallString'

Correct NoSQL Booster Registry - InstallLocation:
  reg.present:
    - name: '{{ reg_key }}'
    - onchanges:
      - cmd: 'Install NoSQL Booster'
    - require:
      - cmd: 'Install NoSQL Booster'
    - vdata: '{{ nosql_booster.config.install_root }}'
    - vname: 'InstallLocation'

Correct NoSQL Booster Registry - UninstallString:
  reg.present:
    - name: '{{ reg_key }}'
    - onchanges:
      - cmd: 'Install NoSQL Booster'
    - require:
      - cmd: 'Install NoSQL Booster'
    - vdata: '"{{ nosql_booster.config.install_root }}\Uninstall NoSQLBooster for MongoDB.exe" /allusers'
    - vname: 'UninstallString'

Create Installation Junction:
  cmd.run:
    - name: 'mklink /J {{ junction }} "{{ nosql_booster.config.install_root }}"'
    - onchanges:
      - file: 'Download NoSQL Booster Installer-EXE'
    - require:
      - file: 'Ensure NoSQL Booster Install Directory'
    - unless: 'if exist {{ junction }} (exit 0) else (exit 1)'

Download NoSQL Booster Installer-EXE:
  file.managed:
    - name: '{{ installer_exe }}'
    {%- if nosql_booster.pkg.download_sig %}
    - skip_verify: False
    - source_hash: '{{ nosql_booster.pkg.download_sig }}'
    {%- else %}
    - skip_verify: True
    {%- endif %}
    - source: '{{ nosql_booster.pkg.download_uri }}'

Ensure NoSQL Booster Install Directory:
  file.directory:
    - group: 'Administrators'
    - makedirs: True
    - name: '{{ nosql_booster.config.install_root }}'
    - user: 'Administrators'

Install NoSQL Booster:
  cmd.run:
    - creates: '{{ nosql_booster.config.install_root }}\NoSQLBooster for MongoDB.exe'
    - name: 'start /wait "" "{{ installer_exe }}" /S /allusers /D={{ junction }}'
    - onchanges:
      - cmd: 'Create Installation Junction'
    - require:
      - cmd: 'Create Installation Junction'
{%- endif %}
