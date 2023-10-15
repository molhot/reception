#!/bin/bash
echo "mariadb install"
if [ ! -d /run/mysqld ]
then
  mkdir -p /run/mysqld
  chown -R mysql:mysql /run/mysqld
  chown -R mysql:mysql /var/lib/mysql

  mysql_install_db --basedir=/usr --datadir=/var/lib/mysql --user=mysql --rpm > /dev/null

cat << EOF > init.sql
    USE mysql;
    FLUSH PRIVILEGES;

    DELETE FROM mysql.user WHERE User='';
    DROP DATABASE test;
    DELETE FROM mysql.db WHERE Db='test';
    
    DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
    
    ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';

    CREATE USER '$WP_DATABASE_USER'@'%' IDENTIFIED by '$WP_DATABASE_PASSWORD';
    GRANT ALL PRIVILEGES ON $WP_DATABASE_NAME.* TO '$WP_DATABASE_USER'@'%';
    FLUSH PRIVILEGES;

    DROP DATABASE IF EXISTS $WP_DATABASE_NAME;
    CREATE DATABASE $WP_DATABASE_NAME CHARACTER SET utf8;
EOF
mysqld --user=mysql --bootstrap < init.sql
fi
exec mysqld --user=mysql --console