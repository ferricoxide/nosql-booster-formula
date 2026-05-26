# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as nosql_booster with context %}

{%- if not nosql_booster.pkg.download_uri %}
NoSQL Booster download URL is missing:
  test.fail_without_changes:
    - comment: |
        --------------------------------------------------
        The vendor URL is subject to change and no
        fallback mechanism is currently able to be
        implemented. Therefore, a valid NoSQL Booster
        download URL *must* be provided via Pillar. If not
        self-hosting, please check:

          https://nosqlbooster.com/downloads

        For valid download URLs.
        --------------------------------------------------
    - name: "CRITICAL: 'nosql_booster:pkg:download_uri' is not defined."
{%- else %}

Ensure NoSQL Booster Install-root:
  file.directory:
    - group: root
    - makedirs: True
    - mode: 755
    - name: '{{ nosql_booster.config.install_root }}'
    - user: root

Install NoSQL Booster Dependencies:
  pkg.installed:
    - pkgs:
      - alsa-lib
      - at-spi2-atk
      - atk
      - cups-libs
      - dbus-glib
      - dejavu-sans-fonts
      - gtk3
      - libX11
      - libX11-xcb
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
      - libsecret
      - libva
      - libxkbcommon
      - libxshmfence
      - mesa-libgbm
      - nss
      - nss-tools
      - pango
      - vulkan-loader
      - xorg-x11-xauth

Install NoSQL Booster:
  archive.extracted:
    - enforce_toplevel: False
    - name: '{{ nosql_booster.config.install_root }}'
    - options: --strip-components=1
    - require:
      - file: 'Ensure NoSQL Booster Install-root'
    - skip_verify: True
    - source: '{{ nosql_booster.pkg.download_uri }}'
    {%- if nosql_booster.pkg.download_sig %}
    - source_hash: '{{ nosql_booster.pkg.download_sig }}'
    {%- else %}
    - skip_verify: True
    {%- endif %}

User binary wrapper:
  file.managed:
    - contents: |
        #!/bin/bash
        #
        # Launch NoSQL Booster utility while suppressing spurious warnings
        #
        ######################################################################
        export APPIMAGE=''
        export ELECTRON_DISABLE_SECURITY_WARNINGS='true'
        export NODE_ENV='production'
        exec '{{ nosql_booster.config.install_root }}/nosqlbooster4mongo' "$@"
    - mode: '0755'
    - name: '/usr/local/bin/nosqlbooster'
    - require:
      - archive: 'Install NoSQL Booster'
{%- endif %}
