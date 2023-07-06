FROM debian:buster

ENV debian_release="buster"

RUN apt-get update \
  && apt-get install -y systemd ca-certificates nginx

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY conf/default.conf /etc/nginx/conf.d/default.conf

# SSL
RUN apt-get update \
  && apt-get install openssl
COPY tools/enable_ssl.sh /tmp/enable_ssl.sh
RUN bash /tmp/enable_ssl.sh

# create user "nginx"
RUN adduser --system --group --no-create-home nginx

CMD [ "/usr/sbin/nginx" ]