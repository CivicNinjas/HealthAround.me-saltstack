healthgeist_db:
    postgres_database.present:
        - name: healthgeist
    file.managed:
        - name: /usr/local/bin/setup_healthgeist_db_gis.sh
        - source: salt://setup_db
        - mode: 755
    cmd.wait:
        - name: /usr/local/bin/setup_healthgeist_db_gis.sh
        - user: postgres
        - watch:
            - postgres_database: healthgeist_db
