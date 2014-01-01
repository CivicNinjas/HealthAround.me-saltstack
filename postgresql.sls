/home/postgresql/:
    file.directory:
        - user: postgres
        - group: postgres
        - mode: 700
        - makedirs: True

postgresql:
    pkg:
        - installed
    service:
        - running
        - reload: True
        - watch:
            - file: /etc/postgresql/9.1/main/postgresql.conf

/etc/postgresql/9.1/main/postgresql.conf:
    file.managed:
        - source: salt://etc/postgresql/9.1/main/postgresql.conf
        - require:
            - pkg: postgresql

postgis:
    pkg:
        - installed
        - require:
            - pkg: postgresql

postgresql-9.1-postgis:
    pkg:
        - installed
        - require:
            - pkg: postgis

psql-utils:
    pkg.installed:
        - names:
            - pgadmin3
            - postgresql-client
        - require:
            - pkg: postgresql

# vim:set ft=yaml:
