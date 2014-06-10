{%- set app_cwd = '/var/www/healtharoundme/' -%}
{%- set frontend_cwd = '/var/www/healtharoundme-frontend/' -%}

####### API

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

shapeimporterpkgs:
    pkg.installed:
        - pkgs:
            - gdal-bin
            - zip
            - unzip

##### Frontend

healtharoundme-frontend:
    git.latest:
        - name: https://github.com/CivicNinjas/HealthAround.me-frontend.git
        - target: {{frontend_cwd}}

nodejs:
    pkgrepo.managed:
        - ppa: chris-lea/node.js
        - required_in:
            - pkg: nodejs
    pkg.installed:
        - require:
            - pkgrepo: nodejs

gulp_requirements:
    cmd.wait:
        - name: npm install
        - cwd: {{frontend_cwd}}
        - watch:
            - git: healtharoundme-frontend

bower:
    npm.installed:
        - require:
            - pkg: nodejs
    cmd.wait:
        - name: bower install --allow-root
        - cwd: {{frontend_cwd}}
        - watch:
            - git: healtharoundme-frontend
        - require:
            - cmd: gulp_requirements

coffeeify_fix:  # this is temporary until frontends package.json is fixed
    cmd.wait:
        - name: npm install coffeeify
        - cwd: {{frontend_cwd}}
        - watch:
            - git: healtharoundme-frontend
        - require:
            - cmd: gulp_requirements

gulp_build:
    cmd.wait:
        - name: npm run build
        - cwd: {{frontend_cwd}}
        - watch:
            - git: healtharoundme-frontend
        - require:
            - cmd: bower
            - cmd: gulp_requirements

# vim: set ft=yaml:
