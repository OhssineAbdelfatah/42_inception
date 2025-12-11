#!/bin/sh

#wait for maria db to be ready
# We use 'mariadb-admin ping' which is included in mariadb-client.
#echo "Waiting for MariaDB to be ready..."
while ! mariadb-admin ping -h"$SQL_HOST" -u"$SQL_USER" -p"$SQL_PASSWORD" --silent; do
	sleep 1
done
echo "MariaDB is ready!"

#rm -f latest.tar.gz

if [ -f ./wp-config.php ]
then
	echo "WordPress already installed"
else
	echo "Downloading WordPress ..."
	rm -f latest.tar.gz
	wget http://wordpress.org/latest.tar.gz
	tar xfz latest.tar.gz
	cp -R wordpress/* .
	rm -rf latest.tar.gz
	rm -rf wordpress

	echo "Configuring WordPress..."
	wp config create --allow-root \
		--dbname=$SQL_DATABASE \
		--dbuser=$SQL_USER \
		--dbpass=$SQL_PASSWORD \
		--dbhost=$SQL_HOST \
		--path='/var/www/html'
	echo "Install Wordpress Core ..."
	wp core install --allow-root \
		--url=$DOMAIN_NAME \
		--title=$SITE_TITLE \
		--admin_user=$ADMIN_USER \
		--admin_password=$ADMIN_PASSWORD \
		--admin_email=$ADMIN_EMAIL \
		--path='/var/www/html'
	echo "Creating Second user ..."
	wp user create --allow-root \
		$USER1_LOGIN $ $USER1_EMAIL \
		--user_pass=$USER1_PASS \
		--role=author \
		--path='/var/www/html'
fi

echo "Starting PHP-FMP"
exec php-fpm82 -F
