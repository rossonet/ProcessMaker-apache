#!/bin/bash
if [ ! -f ".env" ]; then

    echo "---------------"
    echo "Configuration parameters\n"
    echo "PM_APP_PORT -> ${PM_APP_PORT}"
    echo "PM_APP_URL -> ${PM_APP_URL}"
    echo "PM_BROADCASTER_PORT -> ${PM_BROADCASTER_PORT}"
    echo "PM_ADMIN_MAIL -> ${PM_BROADCASTER_PORT}"
    if [ -z ${PM_ADMIN_PASSWORD} ]; then
	echo "PM_ADMIN_PASSWORD ->"
    else 
	echo "PM_ADMIN_PASSWORD -> xxxxxxxxxxxx"
    fi
    echo "MYSQL_HOST -> ${MYSQL_HOST}"
    echo "MYSQL_PORT -> ${MYSQL_PORT}"
    echo "MYSQL_DBNAME -> ${MYSQL_DBNAME}"
    echo "MYSQL_USERNAME -> ${MYSQL_USERNAME}"
    if [ -z ${MYSQL_PASSWORD} ]; then
	echo "MYSQL_PASSWORD ->"
    else 
	echo "MYSQL_PASSWORD -> xxxxxxxxxxxx"
    fi
    if [ -z ${MYSQL_ROOT_PASSWORD} ]; then
	echo "MYSQL_ROOT_PASSWORD ->"
    else 
	echo "MYSQL_ROOT_PASSWORD -> xxxxxxxxxxxx"
    fi
    echo "REDIS_HOST -> ${REDIS_HOST}"
    echo "---------------"

    while ! mysqladmin ping -u root -p${MYSQL_ROOT_PASSWORD} -h ${MYSQL_HOST} --silent; do
        echo "Waiting for mysql..."
        sleep 10
    done

    echo "CREATE DATABASE IF NOT EXISTS ${MYSQL_DBNAME};" | mysql -u root -h ${MYSQL_HOST} -p${MYSQL_ROOT_PASSWORD}
    echo "CREATE USER '${MYSQL_USERNAME}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';" | mysql -u root -h ${MYSQL_HOST} -p${MYSQL_ROOT_PASSWORD}
    echo "GRANT ALL PRIVILEGES ON ${MYSQL_DBNAME}.* TO '${MYSQL_USERNAME}'@'%';" | mysql -u root -h ${MYSQL_HOST} -p${MYSQL_ROOT_PASSWORD}


    if [ "${PM_APP_PORT}" = "80" ]; then
        PORT_WITH_PREFIX=""
    else
        PORT_WITH_PREFIX=":${PM_APP_PORT}"
    fi

    php artisan processmaker:install --no-interaction \
    --url=${PM_APP_URL}${PORT_WITH_PREFIX} \
    --broadcast-host=${PM_APP_URL}:${PM_BROADCASTER_PORT} \
    --username=admin \
    --password=${PM_ADMIN_PASSWORD} \
    --email=${PM_ADMIN_MAIL} \
    --first-name=Admin \
    --last-name=User \
    --db-host=${MYSQL_HOST} \
    --db-port=${MYSQL_PORT} \
    --db-name=${MYSQL_DBNAME} \
    --db-username=${MYSQL_USERNAME} \
    --db-password=${MYSQL_PASSWORD} \
    --data-driver=mysql \
    --data-host=${MYSQL_HOST} \
    --data-port=${MYSQL_PORT} \
    --data-name=${MYSQL_DBNAME} \
    --data-username=${MYSQL_USERNAME} \
    --data-password=${MYSQL_PASSWORD} \
    --redis-host=${REDIS_HOST}

    echo "PROCESSMAKER_SCRIPTS_DOCKER=/usr/local/bin/docker" >> .env
    echo "PROCESSMAKER_SCRIPTS_DOCKER_MODE=copying" >> .env
    echo "LARAVEL_ECHO_SERVER_AUTH_HOST=http://localhost" >> .env
    echo "SESSION_SECURE_COOKIE=false" >> .env
fi

echo "start ProcessMaker..."
supervisord --nodaemon
