nosql-booster:
  lookup:
    pkg:
      {%- if grains.os_family == "RedHat" %}
      download_uri: 'https://s3.nosqlbooster.com/download/releasesv10/nosqlbooster4mongo-10.1.7.tar.gz'
      {%- endif %}
