#!/bin/bash

# TODO: development usage notes
# docker run -v docker start mysql

# docker run -d snipe-mysql
# docker run -d -v snipe-it/:/var/www/html -p $(boot2docker ip)::80   --link snipe-mysql:mysql --name=snipeit snipeit
docker run --name snipe-mysql -e MYSQL_ROOT_PASSWORD=my_crazy_super_secret_root_password -e MYSQL_DATA-BASE=snipeit \
-e MYSQL_USER=snipeit -e MYSQL_PASSWORD=whateverdood -d mysql:5.7


# issues getting this mountpoint to work? TODO: revisit easy develop mounting best-practices
# -v ./snipe-it/:/var/www/html \
# -v ./volume-dev/snipe-it-storage:/var/lib/snipeit snipe-it:develop

docker run --link snipe-mysql:mysql -p 32782:80 --name=snipe-it --mount source=mounted_storage,dst=/var/lib/snipeit
 --env-file docker/docker.env -e DB_PASSWORD=my_crazy_super_secret_root_password -e DB_DATABASE=snipeit \
-e DB_USERNAME=snipeit -e DB_PASSWORD=whateverdood -d snipe/snipe-it:develop

# Testing docker-remoteDB connections using localhosts MySQL Server on mac: DB_HOST=host.docker.internal