FROM ubuntu:16.04

WORKDIR /docker_gamos

ADD . /docker_gamos
ADD fetch_and_run.sh /usr/local/bin/fetch_and_run.sh

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends apt-utils
RUN ./installMissingPackages.DockerUbuntu.sh
RUN ./installGamos.sh /docker_gamos/gamos

ENTRYPOINT ["/docker_gamos/fetch_and_run.sh"]
