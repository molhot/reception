FROM debian:buster

# Utils
RUN apt-get update && apt-get install -y vim git wget

# PHP
RUN apt-get update \
  && apt-get install -y \
  php \
  php-fpm \
  php-mbstring \
  php-pdo \
  php-mysqlnd \
  mariadb-client \
  sendmail \
  curl \
  vim

# wp-cli
RUN apt-get update && \
  apt-get install -y curl

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
  chmod +x wp-cli.phar && \
  mv wp-cli.phar /usr/local/bin/wp

# WordPress
WORKDIR /var/www/html
COPY ./tools/configure.sh /tmp/configure.sh

CMD [ "bash", "/tmp/configure.sh"]