gdal:
    pkgrepo.managed:
        - ppa: ubuntugis/ppa

gdal-bin:
    pkg.installed:
        - require:
            - pkgrepo: gdal

# vim:set ft=yaml:
