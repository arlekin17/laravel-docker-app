FROM dpage/pgadmin4:9.12 AS builder
USER root
RUN mkdir -p /var/lib/pgadmin /var/log/pgadmin \
    && chown -R 5050:5050 /var/lib/pgadmin /var/log/pgadmin

FROM dpage/pgadmin4:9.12 AS production
COPY --from=builder --chown=5050:5050 /var/lib/pgadmin /var/lib/pgadmin
COPY --from=builder --chown=5050:5050 /var/log/pgadmin /var/log/pgadmin
USER pgadmin
