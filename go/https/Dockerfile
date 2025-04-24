# syntax=docker/dockerfile:1
# check=error=true

# SPDX-FileCopyrightText: © 2024 Sebastian Davids <sdavids@gmx.de>
# SPDX-License-Identifier: Apache-2.0

# https://docs.docker.com/engine/reference/builder/

### healthcheck builder ###

# https://hub.docker.com/_/golang/
FROM golang:1.24.2-alpine3.21 AS healthcheck

WORKDIR /app

COPY go.sum go.mod ./

RUN go mod download

COPY cmd cmd

RUN CGO_ENABLED=0 GOOS=linux go build -ldflags '-s -w -B none' -buildvcs=false -o target/healthcheck cmd/healthcheck.go

LABEL de.sdavids.docker.group="sdavids-docker-healthcheck" \
      de.sdavids.docker.type="builder"

### HTTPS server ###

# https://hub.docker.com/_/nginx/
FROM nginx:1.28.0-alpine3.21-slim AS https_server

RUN mkdir -p /usr/share/nginx/html/-/health && \
    touch /usr/share/nginx/html/-/health/liveness && \
    printf '<!doctype html><title>sdavids-docker-healthcheck-go-https</title><h1>sdavids-docker-healthcheck-go-https</h1>' > /usr/share/nginx/html/index.html && \
    printf 'server {listen 3000 ssl;listen [::]:3000 ssl;ssl_certificate /etc/ssl/certs/server.crt;ssl_certificate_key /etc/ssl/private/server.key;location / {root /usr/share/nginx/html;index index.html;}}' > /etc/nginx/conf.d/default.conf

LABEL de.sdavids.docker.group="sdavids-docker-healthcheck" \
      de.sdavids.docker.type="builder"

### final ###

FROM https_server

EXPOSE 3000

COPY --from=healthcheck \
  /app/target/healthcheck \
  /usr/local/bin/healthcheck

HEALTHCHECK --interval=5s --timeout=5s --start-period=5s \
    CMD healthcheck || exit 1

# https://github.com/opencontainers/image-spec/blob/master/annotations.md
LABEL org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.vendor="Sebastian Davids" \
      org.opencontainers.image.title="healthcheck-go-https" \
      de.sdavids.docker.group="sdavids-docker-healthcheck" \
      de.sdavids.docker.type="development" \
      maintainer="Sebastian Davids <sdavids@gmx.de>"
