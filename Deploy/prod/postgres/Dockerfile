FROM golang:1.26.2-alpine3.23 AS gosu-builder
WORKDIR /tmp/gosu
RUN apk add --no-cache git \
    && git clone --depth 1 --branch 1.19 https://github.com/tianon/gosu.git . \
    && CGO_ENABLED=0 go build -ldflags="-s -w" -o /usr/local/bin/gosu . \
    && rm -rf /var/cache/apk/*

FROM postgres:17.9-alpine3.23 AS production
COPY --from=gosu-builder /usr/local/bin/gosu /usr/local/bin/gosu
RUN apk upgrade --no-cache \
    && rm -rf /var/cache/apk/*
USER postgres
