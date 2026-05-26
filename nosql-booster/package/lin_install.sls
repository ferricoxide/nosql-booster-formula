# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as nosql_booster with context %}

Ensure NoSQL Booster Install-root:
  file.directory:
    - name: '{{ nosql_booster.config.install_root }}'
    - user: root
    - group: root
    - mode: 755
    - makedirs: True

Install NoSQL Booster Dependencies:
  pkg.installed:
    - pkgs:
      - alsa-lib
      - at-spi2-atk
      - atk
      - cups-libs
      - dejavu-sans-fonts
      - gtk3
      - libX11
      - libXScrnSaver
      - libXcomposite
      - libXcursor
      - libXdamage
      - libXext
      - libXfixes
      - libXi
      - libXrandr
      - libXrender
      - libXtst
      - libdrm
      - mesa-libgbm
      - nss
      - pango

Install NoSQL Booster:
  archive.extracted:
    - enforce_toplevel: False
    - name: '{{ nosql_booster.config.install_root }}'
    - options: --strip-components=1
    - require:
      - file: 'Ensure NoSQL Booster Install-root'
    - skip_verify: True
    - source: '{{ nosql_booster.pkg.download_uri }}'
    - source_hash: '{{ nosql_booster.pkg.download_sig }}'

User symlink:
  file.symlink:
    - name: '/usr/local/bin/nosqlbooster'
    - target: /opt/nosqlbooster/nosqlbooster4mongo
    - force: True
    - require:
      - archive: 'Install NoSQL Booster'
