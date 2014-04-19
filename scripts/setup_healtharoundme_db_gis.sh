#!/bin/bash
psql -d healtharoundme -c "CREATE EXTENSION postgis;"
psql -d healtharoundme -c "CREATE EXTENSION postgis_topology;"

