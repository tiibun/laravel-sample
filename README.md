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
