# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_package_install = tplroot ~ '.package.install' %}
{%- from tplroot ~ "/map.jinja" import mapdata as nosql_booster with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

Ensure NoSQL Booster Binary is Executable:
  file.managed:
    - mode: '755'
    - name: '{{ nosql_booster.config.install_root }}/nosqlbooster4mongo'
    - replace: False
    - require:
      - file: 'Ensure NoSQL Booster Contents are Readable'

Ensure NoSQL Booster Contents are Readable:
  file.directory:
    - dir_mode: '755'
    - file_mode: '644'
    - group: 'root'
    - name: '{{ nosql_booster.config.install_root }}'
    - recurse:
      - 'group'
      - 'mode'
      - 'user'
    - require:
      - sls: '{{ sls_package_install }}'
    - user: 'root'

{%- if nosql_booster.config.get('license_string') %}
Install Pillar-Supplied License-String:
  file.managed:
    - contents: '{{ nosql_booster.config.license_string }}'
    - group: 'root'
    - makedirs: True
    - name: '/etc/skel/.config/nosqlbooster4mongo/license.key'
    - require:
      - file: 'Ensure NoSQL Booster Contents are Readable'
    - user: 'root'
{%- endif %}

NoSQL Booster Desktop Entry:
  file.managed:
    - context:
        install_root: '{{ nosql_booster.config.install_root }}'
    - group: 'root'
    - mode: '644'
    - name: '/usr/share/applications/nosqlbooster.desktop'
    - require:
      - sls: '{{ sls_package_install }}'
    - source: {{ files_switch(
          ["nosqlbooster.desktop.jinja"],
          lookup="NoSQL Booster Desktop Entry"
        ) }}
    - template: 'jinja'
    - user: 'root'

{%- if grains.get('selinux:enabled', False) %}
Restore NoSQL Booster Context:
  cmd.run:
    - name: '/sbin/restorecon -R "{{ nosql_booster.config.install_root }}"'
    - onchanges:
      - selinux: 'Set NoSQL Booster Binary SELinux Context'
      - selinux: 'Set NoSQL Booster Directory SELinux Context'
    - require:
      - selinux: 'Set NoSQL Booster Binary SELinux Context'
      - selinux: 'Set NoSQL Booster Directory SELinux Context'
      - sls: '{{ sls_package_install }}'

Set NoSQL Booster Binary SELinux Context:
  selinux.fcontext_policy_present:
    - name: '{{ nosql_booster.config.install_root }}/nosqlbooster4mongo'
    - require:
      - sls: '{{ sls_package_install }}'
    - sel_type: 'bin_t'

Set NoSQL Booster Directory SELinux Context:
  selinux.fcontext_policy_present:
    - name: '{{ nosql_booster.config.install_root }}(/.*)?'
    - require:
      - sls: '{{ sls_package_install }}'
    - sel_type: 'usr_t'
{%- endif %}
