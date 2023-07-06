#!/bin/bash

is_wpuser_created() {
  mysql --protocol=socket -u"$WP_DATABASE_USER" -p"$WP_DATABASE_PASSWORD" -hlocalhost --database="$WP_DATABASE_NAME" -e 'SELECT 1' &> /dev/null
}

# Do a temporary startup of the MariaDB server, for init purposes
docker_temp_server_start() {
  "$@" &
  echo "Waiting for server startup"
  # only use the root password if the database has already been initializaed
  # so that it won't try to fill in a password file when it hasn't been set yet
  local i
  for i in {30..0}; do
    if MYSQL_PWD=$MYSQL_ROOT_PASSWORD mysql --protocol=socket -uroot -hlocalhost --database=mysql -e 'SELECT 1' &> /dev/null; then
      break
    fi
    sleep 1
  done
  if [ "$i" = 0 ]; then
    echo "Unable to start server."
    exit 1
  fi
}

# Stop the server. When using a local socket file mariadb-admin will block until
# the shutdown is complete.
docker_temp_server_stop() {
  if ! MYSQL_PWD=$MYSQL_ROOT_PASSWORD mysqladmin shutdown -uroot ; then
    mysql_error "Unable to shut down server."
  fi
}

configure_wpuser() {
  TEMP_SQL_PATH="/tmp/init.sql"

  # https://stackoverflow.com/questions/10299148/mysql-error-1045-28000-access-denied-for-user-billlocalhost-using-passw
  cat << EOF > $TEMP_SQL_PATH
USE mysql;
FLUSH PRIVILEGES;
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';

DROP DATABASE IF EXISTS $WP_DATABASE_NAME;
CREATE DATABASE $WP_DATABASE_NAME CHARACTER SET utf8;
CREATE USER '$WP_DATABASE_USER'@'%' IDENTIFIED by '$WP_DATABASE_PASSWORD';
GRANT ALL PRIVILEGES ON $WP_DATABASE_NAME.* TO '$WP_DATABASE_USER'@'%';
FLUSH PRIVILEGES;
EOF

  # execute init.sql
  echo "execute ${TEMP_SQL_PATH}"
  MYSQL_PWD=$MYSQL_ROOT_PASSWORD mysql --protocol=socket -uroot -hlocalhost < $TEMP_SQL_PATH
  rm -f $TEMP_SQL_PATH
}

# $1 には daemon 名を渡す
_main() {
  echo '$@:' "$@"
  mkdir -p /run/mysqld
  chown -R mysql:mysql /run/mysqld

  chown -R mysql:mysql /var/lib/mysql

  # initialize datadir
  mysql_install_db --basedir=/usr --datadir=/var/lib/mysql --user=mysql --rpm > /dev/null

  echo "Starting temporary server"
  docker_temp_server_start "$@"
  echo "Temporary server started."

  if ! is_wpuser_created; then
    configure_wpuser
  fi

  echo "Stopping temporary server"
  docker_temp_server_stop
  echo "Temporary server stopped"

  # allow remote connections
  sed -i "s|skip-networking|# skip-networking|g" /etc/mysql/mariadb.conf.d/50-server.cnf
  sed -i "s|.*bind-address\s*=.*|bind-address=0.0.0.0|g" /etc/mysql/mariadb.conf.d/50-server.cnf

  exec "$@"
}

_main mysqld_safe