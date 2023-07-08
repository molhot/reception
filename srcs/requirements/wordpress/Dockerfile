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
  php-mysql \
  php-mysqlnd \
  mariadb-client \
  sendmail \
  curl \
  vim

# wp-cli
RUN apt-get update && \
  apt-get install -y curl

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
  chmod u+x wp-cli.phar && \
  mv wp-cli.phar /usr/local/bin/wp

RUN sed -i "s|listen = /run/php/php7.3-fpm.sock|listen = 9000|g" /etc/php/7.3/fpm/pool.d/www.conf
RUN sed -i "s|skip-networking|# skip-networking|g" /etc/php/7.3/fpm/pool.d/www.conf

# WordPress
WORKDIR /var/www/html
COPY ./tools/configure.sh /tmp/configure.sh
RUN chmod +x /tmp/configure.sh

ENTRYPOINT ["/tmp/configure.sh"]