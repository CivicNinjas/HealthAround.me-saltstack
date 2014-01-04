redis-server:
    pkg:
        - installed
    service:
        - running
        - watch:
            - file: /etc/redis/redis.conf
    file.managed:
        - name: /etc/redis/redis.conf
        - source: salt://etc/redis/redis.conf
        - user: redis
        - group: redis
        - mode: 660
        - require:
            - pkg: redis-server

# vim:set ft=yaml:
