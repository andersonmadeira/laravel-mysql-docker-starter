# 🚀 🐋  laravel-mysql-docker-starter

A starting point for running laravel + mysql apps in docker containers

## Instructions

### Docker

Build the app image:

`docker-compose build`

Run:

`docker-compose up -d`

View logs:

`docker-composer logs -f`

### PHP

Install composer packages:

`docker exec -it laravel-app bash -c "sudo -u devuser /bin/bash" -c composer install`

Generate the app secret key:

`docker exec -it laravel-app bash -c "sudo -u devuser /bin/bash" -c php artisan key:generate`

Database migration:

`docker exec -it laravel-app bash -c "sudo -u devuser /bin/bash" -c php artisan migrate`

### Your app

fire your browser at:

`localhost:8080`

To query the database use `phpmyadmin`:

`localhost:8888`

using the user `root` and the password provided in `.env`

