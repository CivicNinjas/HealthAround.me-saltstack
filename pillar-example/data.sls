users:
    - user1

postgres:
    users:
        app_user:
            password: djangouserspassword
    app_owner: app_user
    app_db: healthgeist

django:
    allowed_host: '*'
    db_engine: postgres
    db_engine_module: django.db.backends.postgresql_psycopg2
    secret_key: KEEPitSECRETkeepITsafe
