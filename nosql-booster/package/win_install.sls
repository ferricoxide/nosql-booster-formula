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
Download NoSQL Booster Installer-EXE:
  file.managed:
    - name: '{{ installer_exe }}'
    - source: '{{ nosql_booster.pkg.download_uri }}'
    {%- if nosql_booster.pkg.download_sig %}
    - source_hash: '{{ nosql_booster.pkg.download_sig }}'
    {%- else %}
    - skip_verify: True
    {%- endif %}

Install NoSQL Booster:
  cmd.run:
    - name: >
        Start-Process
        -FilePath "{{ installer_exe }}"
        -ArgumentList "/S", "/allusers",
        "/D={{ nosql_booster.config.install_root }}"
        -Wait
    - onchanges:
      - file: 'Download NoSQL Booster Installer-EXE'
    - shell: powershell
{%- endif %}
