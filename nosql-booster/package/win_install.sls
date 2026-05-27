# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
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
    - comment: {{ nosql_booster.pkg.download_uri_error | indent(8) }}
    - name: "CRITICAL: 'nosql_booster:pkg:download_uri' is not defined."
{%- elif not nosql_booster.pkg.reg_guid %}
NoSQL Booster registry GUID is missing:
  test.fail_without_changes:
    - name: "CRITICAL: Registry ProductCode GUID is not defined."
    - comment: |
        --------------------------------------------------
        The 'nosql_booster:pkg:reg_guid' is not defined in
        Pillar. This GUID (ProductCode) is required on
        Windows to perform registry corrections and ensure
        uninstaller functionality.
        --------------------------------------------------
{%- else %}
Cleanup Installation Junction:
  cmd.run:
    - name: 'rmdir {{ junction }}'
    - onchanges:
      - cmd: 'Install NoSQL Booster'

Correct NoSQL Booster Registry - InstallLocation:
  reg.present:
    - name: '{{ reg_key }}'
    - onchanges:
      - cmd: 'Install NoSQL Booster'
    - vdata: '{{ nosql_booster.config.install_root }}'
    - vname: 'InstallLocation'

Correct NoSQL Booster Registry - UninstallString:
  reg.present:
    - name: '{{ reg_key }}'
    - onchanges:
      - cmd: 'Install NoSQL Booster'
    - vdata: '"{{ nosql_booster.config.install_root }}\Uninstall NoSQLBooster for MongoDB.exe" /allusers'
    - vname: 'UninstallString'

Create Installation Junction:
  cmd.run:
    - name: 'mklink /J {{ junction }} "{{ nosql_booster.config.install_root }}"'
    - onchanges:
      - file: 'Download NoSQL Booster Installer-EXE'
    - unless: 'if exist {{ junction }} (exit 0) else (exit 1)'

Download NoSQL Booster Installer-EXE:
  file.managed:
    - name: '{{ installer_exe }}'
    - source: '{{ nosql_booster.pkg.download_uri }}'
    {%- if nosql_booster.pkg.download_sig %}
    - source_hash: '{{ nosql_booster.pkg.download_sig }}'
    {%- else %}
    - skip_verify: True
    {%- endif %}

Ensure NoSQL Booster Install Directory:
  file.directory:
    - makedirs: True
    - name: '{{ nosql_booster.config.install_root }}'

Install NoSQL Booster:
  cmd.run:
    - creates: '{{ nosql_booster.config.install_root }}\NoSQLBooster for MongoDB.exe'
    - name: 'start /wait "" "{{ installer_exe }}" /S /allusers /D={{ junction }}'
    - onchanges:
      - cmd: 'Create Installation Junction'
    - require:
      - cmd: 'Create Installation Junction'
{%- endif %}

