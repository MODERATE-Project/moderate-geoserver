FROM ubuntu:24.04 as build
RUN apt-get update -y && apt-get install -y build-essential git curl
WORKDIR /opt
RUN sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d
COPY . .
ENV INIT_DATA_DIR /opt/init_data
RUN GEOSERVER_DATA_DIR="${INIT_DATA_DIR}" ./bin/task download-geoserver-data

FROM kartoza/geoserver:2.24.2 as geoserver
RUN apt-get update -y && apt-get install --no-install-recommends -y rsync
ENV INIT_DATA_DIR /opt/init_data
ENV GEOSERVER_DATA_DIR /opt/geoserver/data_dir
COPY --from=build ${INIT_DATA_DIR} ${INIT_DATA_DIR}
COPY custom-entrypoint.sh /scripts/custom-entrypoint.sh
ENTRYPOINT ["/bin/bash", "/scripts/custom-entrypoint.sh"]
