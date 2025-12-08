#!/bin/sh

set -e

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

DATADIR="/var/lib/mysql"

if [ ! -d "$DATADIR/mysql" ]; then
    echo "Initializing MariaDB data directory..."
    mariadb-install-db --user=mysql --datadir="$DATADIR" > /dev/null

    echo "Starting temporary server to set root password..."
    
    # FIX 1: Explicitly pass the socket path to the server ensures it matches the client
    mariadbd --user=mysql --datadir="$DATADIR" --socket="/run/mysqld/mysqld.sock" --skip-networking &
    pid="$!"

    # FIX 2: Use a standard 'while' loop compatible with Alpine's /bin/sh
    i=30
    while [ $i -gt 0 ]; do
        if mariadb-admin ping --socket="/run/mysqld/mysqld.sock" --silent; then
            echo "Database is ready."
            break
        fi
        echo "Waiting for database to start... ($i)"
        sleep 1
        i=$((i-1))
    done

    if [ $i -eq 0 ]; then
        echo >&2 "Error: Database failed to start within 30 seconds."
        exit 1
    fi

    echo "Setting root password..."
    
    mariadb --socket="/run/mysqld/mysqld.sock" <<-EOSQL
        ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
        CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
        GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
        FLUSH PRIVILEGES;
EOSQL

    echo "Shutting down temporary server..."
    #mariadb-admin shutdown --socket="/run/mysqld/mysqld.sock" -u root -p"${MYSQL_ROOT_PASSWORD}"
    if ! kill -s TERM "$pid" || ! wait "$pid"; then
        echo >&2 "Process failed to shut down cleanly."
    fi
    wait "$pid"
    echo "Initialization finished."
fi

echo "Starting MariaDB server..."
exec mariadbd --user=mysql --console
