redis-server:
    pkg:
        - installed
    service:
        - running
        - watch:
            - file: /etc/redis/redis.conf

/etc/redis/redis.conf:
    file.managed:
        - source: salt://etc/redis/redis.conf
        - user: redis
        - group: redis
        - mode: 660
        - require:
            - pkg: redis-server

# vim:set ft=yaml:
