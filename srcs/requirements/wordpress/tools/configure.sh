#!/bin/bash

set -e

until mysqladmin --host=mariadb --user=$WP_ADMIN_USER --silent ping; do
  >&2 echo "mariadb is sleeping"
  sleep 10
done
  
>&2 echo "mariadb is up - executing command"

if ! wp core is-installed --allow-root --path=/var/www/html/wordpress &> /dev/null ; then
    echo "Install WordPress"
    echo "check text"
    mkdir -p /var/www/wordpress
    wp core download --locale=ja --allow-root --path=/var/www/html/wordpress
    echo "create config"
    sleep 2
    wp config create --force --dbname=$WP_DB_NAME --dbuser=$WP_DB_USER --dbpass=$WP_DB_PASSWORD \
    --dbhost=$WP_DB_HOST --locale=ja --allow-root --path=/var/www/html/wordpress
    sleep 2
    wp core install \
    --url=https://satushi.42.fr --title=$WP_TITLE --admin_user=$WP_ADMIN_USER \
    --admin_password=$WP_ADMIN_PASSWORD --admin_email=$WP_ADMIN_EMAIL \
    --allow-root --path=/var/www/html/wordpress
    sleep 2
    wp user create \
        $WP_USER \
        $WP_EMAIL \
        --user_pass="${WP_PASSWORD}" \
        --allow-root \
        --path=/var/www/html/wordpress
    sleep 2
else
    echo "Install already WordPress"
fi

chown -R www-data:www-data /var/www/html/* \
    && find /var/www/html/ -type d -exec chmod 755 {} + \
    && find /var/www/html/ -type f -exec chmod 644 {} +

# PIDファイル
mkdir -p /run/php

echo "start php-fpm7.3"

exec php-fpm7.3 -R -F