FROM debian:buster

ENV debian_release="buster"

RUN apt-get update \
  && apt-get install -y systemd ca-certificates nginx

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY conf/default.conf /etc/nginx/conf.d/default.conf

RUN apt-get update \
  && apt-get install openssl

RUN mkdir /etc/nginx/ssl
RUN openssl genrsa -out /etc/nginx/ssl/server.key 3072

RUN openssl req -new -key /etc/nginx/ssl/server.key -out /etc/nginx/ssl/server.csr -subj "/CN=example.com"

RUN openssl x509 -req -signkey /etc/nginx/ssl/server.key -in /etc/nginx/ssl/server.csr -out /etc/nginx/ssl/server.crt

RUN adduser --system --group --no-create-home nginx

CMD [ "/usr/sbin/nginx" ]