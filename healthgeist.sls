{%- set app_cwd = '/var/www/healthgeist/' -%}

healthgeist_db:
    postgres_database.present:
        - name: healthgeist
        - owner: {{pillar.postgres.app_owner}}
        - runas: postgres
        - require:
            - postgres_user: pg_user-{{pillar.postgres.app_owner}}
    file.managed:
        - name: /usr/local/bin/setup_healthgeist_db_gis.sh
        - source: salt://scripts/setup_healthgeist_db_gis.sh
        - mode: 755
    cmd.wait:
        - name: /usr/local/bin/setup_healthgeist_db_gis.sh
        - user: postgres
        - watch:
            - postgres_database: healthgeist_db

healthgeist:
    git.latest:
        - name: https://github.com/CivicNinjas/SitegeistHealth.git
        - target: {{app_cwd}}
    file.managed:
        - name: {{app_cwd}}local_settings.py
        - source: salt://healthgeist/local_settings.py
        - mode: 0644
        - template: jinja
        - require:
            - git: healthgeist

pip_requirements:
    cmd.wait:
        - name: pip install -r requirements.txt
        - cwd: {{app_cwd}}
        - watch:
            - git: healthgeist

collect_static:
    cmd.wait:
        - name: python manage.py collectstatic
        - cwd: {{app_cwd}}
        - runas: www-data
        - watch:
            - git: mezzanine

{% for username, user in pillar.postgres.users.items() %}
pg_user-{{username}}:
    postgres_user.present:
        - name: {{username}}
        - password: {{user.password}}
        - encrypted: True
        - superuser: {{user.get('superuser', False)}}
        - runas: postgres
{% endfor %}
