# syntax=docker/dockerfile:1
# check=error=true

# SPDX-FileCopyrightText: © 2024 Sebastian Davids <sdavids@gmx.de>
# SPDX-License-Identifier: Apache-2.0

# https://docs.docker.com/engine/reference/builder/

### healthcheck builder ###

# https://github.com/graalvm/container/pkgs/container/native-image-community
FROM ghcr.io/graalvm/native-image-community:24.0.2-muslib-ol9-20250715 AS healthcheck

# hadolint ignore=DL3041
RUN microdnf install --assumeyes --nodocs "xz-5.2.5-8.el9_0.$(arch)" && microdnf clean all

# https://github.com/upx/upx/releases
RUN UPX_VERSION=5.0.2 && \
    if [ "$(arch)" = 'x86_64' ]; then echo 'amd64' >/tmp/arch; else echo 'arm64' >/tmp/arch; fi && \
    ARCH=$(cat /tmp/arch) && \
    rm /tmp/arch && \
    curl -sL -o upx.tar.xz "https://github.com/upx/upx/releases/download/v${UPX_VERSION}/upx-${UPX_VERSION}-${ARCH}_linux.tar.xz" && \
    xz -d upx.tar.xz && \
    tar -x -C /usr/local/bin --strip-components=1 --no-anchored --no-wildcards upx -f upx.tar && \
    rm upx.tar

WORKDIR /app

COPY src ./

RUN javac --release 21 HealthCheck.java

RUN native-image \
      -march=native \
      -Ob \
      --gc=epsilon \
      --initialize-at-build-time=HealthCheck \
      --install-exit-handlers \
      --enable-http \
      --static \
      --libc=musl \
      -o healthcheck \
      HealthCheck && \
    upx --ultra-brute healthcheck

### HTTP server ###

# https://hub.docker.com/_/nginx/
FROM nginx:1.29.1-alpine3.22-slim AS http_server

RUN mkdir -p /usr/share/nginx/html/-/health && \
    touch /usr/share/nginx/html/-/health/liveness && \
    printf '<!doctype html><title>sdavids-docker-healthcheck-java-http</title><h1>sdavids-docker-healthcheck-java-http</h1>' >/usr/share/nginx/html/index.html && \
    printf 'server {listen 3000;listen [::]:3000;location / {root /usr/share/nginx/html;index index.html;}}' >/etc/nginx/conf.d/default.conf

LABEL de.sdavids.docker.group="sdavids-docker-healthcheck" \
      de.sdavids.docker.type="builder"

### final ###

FROM http_server

EXPOSE 3000

COPY --from=healthcheck \
  /app/healthcheck \
  /usr/local/bin/healthcheck

HEALTHCHECK --interval=5s --timeout=5s --start-period=5s \
    CMD healthcheck || exit 1

# https://github.com/opencontainers/image-spec/blob/master/annotations.md
LABEL org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.vendor="Sebastian Davids" \
      org.opencontainers.image.title="healthcheck-java-http" \
      de.sdavids.docker.group="sdavids-docker-healthcheck" \
      de.sdavids.docker.type="development"
