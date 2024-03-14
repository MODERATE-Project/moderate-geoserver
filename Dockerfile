FROM ubuntu:24.04 as build

RUN apt-get update -y && apt-get install -y \
    build-essential \
    git \
    curl

WORKDIR /opt
RUN sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d
COPY . .
ENV GEOSERVER_DATA_DIR /opt/geoserver/data_dir
RUN GEOSERVER_DATA_DIR="${GEOSERVER_DATA_DIR}" ./bin/task download-geoserver-data

FROM kartoza/geoserver:2.24.2 as geoserver
COPY --from=build /opt/geoserver/data_dir /opt/geoserver/data_dir
