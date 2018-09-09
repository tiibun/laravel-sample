# Laravel install

## create project

```sh
docker run --rm -it -v $PWD:/app -w /app composer create-project --prefer-dist laravel/laravel laravel-sample "5.7.*"
```

## add Docker files

- Dockerfile
- npm.Dockerfile
- docker-compose.yml
- docker
  - nginx
    - conf.d
      - default.conf
  - php
    - conf.d
      - opcache.ini
      - xdebug.ini

## .env

```sh
sed -e 's/DB_HOST=127.0.0.1/DB_HOST=db/' -e 's/REDIS_HOST=127.0.0.1/REDIS_HOST=redis/' -i '' .env
```

## up

```sh
docker-compose up -d
```

## When modify composer.json

```sh
docker-compose run --rm composer install
```

## When modify package.json

```sh
docker-compose run --rm npm install
```
