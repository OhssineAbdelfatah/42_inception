FROM alpine:3.22

RUN apk update && \
    apk add --no-cache mariadb mariadb-client mariadb-server-utils && \
    mkdir -p /run/mysqld && \
    chown -R mysql:mysql /run/mysqld

RUN mkdir -p /var/lib/mysql && \
    chown -R mysql:mysql /var/lib/mysql

COPY ./tools/entrypoint.sh /usr/local/bin/script.sh

RUN chmod +x /usr/local/bin/script.sh

EXPOSE 3306

ENTRYPOINT ["/usr/local/bin/script.sh"] 
