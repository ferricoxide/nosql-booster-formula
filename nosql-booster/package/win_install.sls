# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as nosql_booster with context %}
{%- set installer_exe = nosql_booster.pkg.download_save_dir ~
    '\\nosqlbooster-setup.exe'
%}

{%- if not nosql_booster.pkg.download_uri %}
NoSQL Booster download URL is missing:
  test.fail_without_changes:
    - comment: {{ nosql_booster.pkg.download_uri_error | indent(8) }}
    - name: "CRITICAL: 'nosql_booster:pkg:download_uri' is not defined."

{%- else %}
Cleanup Installation Junction:
  cmd.run:
    - name: 'rmdir {{ junction }}'
    - onchanges:
      - cmd: 'Install NoSQL Booster'

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

