# syntax=docker/dockerfile:1
# check=error=true

# SPDX-FileCopyrightText: © 2024 Sebastian Davids <sdavids@gmx.de>
# SPDX-License-Identifier: Apache-2.0

# https://docs.docker.com/engine/reference/builder/

### healthcheck builder ###

# https://hub.docker.com/_/rust/
FROM rust:1.85.0-alpine3.20 AS healthcheck

RUN apk add --no-cache musl-dev=1.2.5-r1 upx=4.2.4-r0

# https://doc.rust-lang.org/cargo/reference/environment-variables.html#environment-variables-cargo-reads
ENV CARGO_INCREMENTAL=0

WORKDIR /tmp

# https://stackoverflow.com/a/58474618
RUN mkdir src && \
    echo "fn main() {}" > src/main.rs

COPY rust-toolchain.toml ./

COPY Cargo.toml ./

COPY Cargo.lock ./

RUN cargo build --release

COPY src src

RUN touch src/main.rs && \
    cargo build --release --offline && \
    upx --ultra-brute /tmp/target/release/healthcheck

LABEL de.sdavids.docker.group="sdavids-docker-healthcheck" \
      de.sdavids.docker.type="builder"

### HTTPS server ###

# https://hub.docker.com/_/nginx/
FROM nginx:1.27.3-alpine3.20-slim AS https_server

COPY ca.crt /usr/local/share/ca-certificates/

# hadolint ignore=DL3018
RUN apk add --no-cache ca-certificates && \
    update-ca-certificates && \
    mkdir -p /usr/share/nginx/html/-/health && \
    touch /usr/share/nginx/html/-/health/liveness && \
    printf '<!doctype html><title>sdavids-docker-healthcheck-rust-https</title><h1>sdavids-docker-healthcheck-rust-https</h1>' > /usr/share/nginx/html/index.html && \
    printf 'server {listen 3000 ssl;listen [::]:3000 ssl;ssl_certificate /etc/ssl/certs/server.crt;ssl_certificate_key /etc/ssl/private/server.key;location / {root /usr/share/nginx/html;index index.html;}}' > /etc/nginx/conf.d/default.conf

LABEL de.sdavids.docker.group="sdavids-docker-healthcheck" \
      de.sdavids.docker.type="builder"

### final ###

FROM https_server

EXPOSE 3000

COPY --from=healthcheck \
  /tmp/target/release/healthcheck \
  /usr/local/bin/healthcheck

HEALTHCHECK --interval=5s --timeout=5s --start-period=5s \
    CMD healthcheck || exit 1

# https://github.com/opencontainers/image-spec/blob/master/annotations.md
LABEL org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.vendor="Sebastian Davids" \
      org.opencontainers.image.title="healthcheck-rust-https" \
      de.sdavids.docker.group="sdavids-docker-healthcheck" \
      de.sdavids.docker.type="development" \
      maintainer="Sebastian Davids <sdavids@gmx.de>"
