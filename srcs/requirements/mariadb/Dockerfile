FROM debian:buster

RUN apt-get update \
  && apt-get install -y mariadb-server mariadb-client

RUN apt-get update \
  && apt-get install -y vim

COPY tools/configure.sh /tmp/configure.sh

CMD [ "bash", "/tmp/configure.sh" ]