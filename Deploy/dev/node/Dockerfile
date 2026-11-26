FROM node:22-alpine

WORKDIR /app

RUN apk upgrade --no-cache \
    && rm -rf /var/cache/apk/*

CMD ["sh", "-c", "npm ci && npm run dev -- --host 0.0.0.0"]
