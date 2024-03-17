#!/bin/bash

set -x

: ${INIT_DATA_DIR:?} || exit 1
: ${GEOSERVER_DATA_DIR:?} || exit 1

# Ensure the GeoServer data directory exists
mkdir -p ${GEOSERVER_DATA_DIR}

echo "Copying initial data from ${INIT_DATA_DIR} to ${GEOSERVER_DATA_DIR}"

# The -a option stands for "archive", which means it preserves the files' attributes
# The -v option stands for "verbose"
# The --ignore-existing option tells rsync to skip updating files that already exist in the destination directory
rsync -av --ignore-existing ${INIT_DATA_DIR}/ ${GEOSERVER_DATA_DIR}/

set +x

# Delegate to the original entrypoint
# https://github.com/kartoza/docker-geoserver/blob/develop/scripts/entrypoint.sh
exec /scripts/entrypoint.sh "$@"
