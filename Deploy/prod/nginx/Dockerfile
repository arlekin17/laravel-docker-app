FROM nginx:1.28.0-alpine AS config-validator
RUN rm -f /etc/nginx/conf.d/default.conf
COPY default.conf /etc/nginx/conf.d/default.conf

FROM nginx:1.28.0-alpine AS production
RUN apk upgrade --no-cache \
&& rm -rf /var/cache/apk/* \
&& rm -f /etc/nginx/conf.d/default.conf
COPY --from=config-validator /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf
