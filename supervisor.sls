supervisor:
    pkg:
        - installed
    pip.installed:
        - name: gunicorn
    service:
        - running
        - watch:
            - file: /etc/supervisor/conf.d/*.conf
    file.managed:
        - name: /etc/supervisor/conf.d/healtharoundme.conf
        - source: salt://etc/supervisor/conf.d/healtharoundme.conf
        - mode: 644
        - require:
            - pkg: supervisor
    cmd.wait:
        - name: service supervisor stop && service supervisor start
        - watch:
            - file: supervisor
