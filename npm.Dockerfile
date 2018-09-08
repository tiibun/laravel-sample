FROM node:8.11.4-alpine

RUN apk add --no-cache \
    autoconf \
    automake \
    gcc \
    libc-dev \
    libpng-dev \
    libtool \
    make \
    nasm

WORKDIR /app

ENTRYPOINT [ "npm" ]
CMD [ "run", "watch" ]
