{%- set app_cwd = '/var/www/healtharoundme/' -%}

healtharoundme_db:
    postgres_database.present:
        - name: healtharoundme
        - owner: {{pillar.postgres.app_owner}}
        - runas: postgres
        - require:
            - postgres_user: pg_user-{{pillar.postgres.app_owner}}
    file.managed:
        - name: /usr/local/bin/setup_healtharoundme_db_gis.sh
        - source: salt://scripts/setup_healtharoundme_db_gis.sh
        - mode: 755
    cmd.wait:
        - name: /usr/local/bin/setup_healtharoundme_db_gis.sh
        - user: postgres
        - watch:
            - postgres_database: healtharoundme_db

healtharoundme:
    git.latest:
        - name: https://github.com/CivicNinjas/HealthAround.me.git
        - target: {{app_cwd}}
    file.managed:
        - name: {{app_cwd}}settings_override.py
        - source: salt://healtharoundme/settings_override.py
        - mode: 0644
        - template: jinja
        - require:
            - git: healtharoundme

pip_requirements:
    cmd.wait:
        - name: pip install -r requirements.txt
        - cwd: {{app_cwd}}
        - watch:
            - git: healtharoundme

collect_static:
    cmd.wait:
        - name: python manage.py collectstatic --noinput
        - cwd: {{app_cwd}}
        - runas: www-data
        - watch:
            - git: healtharoundme

restart_gunicorn:
    cmd.wait:
        - name: supervisorctl restart gunicorn
        - watch:
            - git: healtharoundme

{% for username, user in pillar.postgres.users.items() %}
pg_user-{{username}}:
    postgres_user.present:
        - name: {{username}}
        - password: {{user.password}}
        - encrypted: True
        - superuser: {{user.get('superuser', False)}}
        - runas: postgres
{% endfor %}
