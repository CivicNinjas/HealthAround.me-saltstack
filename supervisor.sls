supervisor:
    pkg:
        - installed
    service:
        - running
        - watch:
            - file: /etc/supervisor/conf.d/*.conf

/etc/supervisor/conf.d/healthgeist.conf:
    file.managed:
        - source: salt://etc/supervisor/conf.d/healthgeist.conf
        - mode: 644
        - require:
            - pkg: supervisor

/etc/supervisord.conf:
    file.symlink:
        - target: /etc/supervisor/supervisord.conf
        - require:
            - pkg: supervisor
