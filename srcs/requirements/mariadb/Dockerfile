FROM debian:buster

RUN apt-get update && apt-get upgrade -y \
  && apt-get install -y mariadb-server mariadb-client

RUN apt-get update \
  && apt-get install -y vim

COPY ./tools/configure.sh /tmp/configure2.sh
RUN chmod +x /tmp/configure2.sh

RUN sed 's/bind-address            = 127.0.0.1/bind-address            = 0.0.0.0/' -i  /etc/mysql/mariadb.conf.d/50-server.cnf
RUN sed 's/skip-networking/#skip-networking/g' -i  /etc/mysql/mariadb.conf.d/50-server.cnf

RUN echo "exec configure file"

CMD [ "bash", "/tmp/configure2.sh"]