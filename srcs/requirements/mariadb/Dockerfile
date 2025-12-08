FROM alpine:3.22

RUN apk update && \
    apk add --no-cache mariadb mariadb-client mariadb-server-utils && \
    mkdir -p /run/mysqld && \
    chown -R mysql:mysql /run/mysqld

RUN mkdir -p /var/lib/mysql && \
    chown -R mysql:mysql /var/lib/mysql

COPY ./conf/mariadb.conf /etc/my.cnf.d/mariadb-server.cnf
COPY ./tools/entrypoint.sh /usr/local/bin/script.sh

RUN chmod +x /usr/local/bin/script.sh

EXPOSE 3306

VOLUME ["/var/lib/mysql"]

ENTRYPOINT ["/usr/local/bin/script.sh"] 
