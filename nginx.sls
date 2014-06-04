nginx:
    pkgrepo.managed:
        - ppa: nginx/stable 
        - required_in:
            - pkg: nginx
    pkg.installed:
        - require:
            - pkgrepo: nginx
    service:
        - running
        - watch:
            - file: /etc/nginx/sites-available/api
            - file: /etc/nginx/sites-enabled/api
            - file: /etc/nginx/sites-available/default
            - file: /etc/nginx/sites-enabled/default

/etc/nginx/sites-available/api:
    file.managed:
        - source: salt://etc/nginx/sites-available/api
        - require:
            - pkg: nginx

/etc/nginx/sites-enabled/api:
    file.symlink:
        - target: /etc/nginx/sites-available/api
        - require:
            - file: /etc/nginx/sites-available/api

/etc/nginx/sites-available/default:
    file.managed:
        - source: salt://etc/nginx/sites-available/default
        - require:
            - pkg: nginx

/etc/nginx/sites-enabled/default:
    file.symlink:
        - target: /etc/nginx/sites-available/default
        - require:
            - file: /etc/nginx/sites-available/default

# vim:set ft=yaml:
