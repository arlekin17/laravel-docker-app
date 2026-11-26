FROM postgres:17.12-alpine3.24 AS production

RUN apk upgrade --no-cache \
    && rm -f /usr/local/bin/gosu \
    && rm -rf /var/cache/apk/*

USER postgres
