#!/usr/bin/env sh

# SPDX-FileCopyrightText: © 2024 Sebastian Davids <sdavids@gmx.de>
# SPDX-License-Identifier: Apache-2.0

set -eu

readonly http_port="${1:-3000}"

readonly tag='local'

# https://docs.docker.com/reference/cli/docker/image/tag/#description
readonly namespace='de.sdavids'
readonly repository='sdavids-docker-healthcheck'

readonly label_group='de.sdavids.docker.group'

readonly label="${label_group}=${repository}"

readonly image_name="${namespace}/${repository}"

readonly container_name='sdavids-docker-healthcheck-js-nodejs'

readonly host_name='localhost'

readonly network_name="${repository}"

docker network inspect "${network_name}" >/dev/null 2>&1 \
  || docker network create \
    --driver bridge "${network_name}" \
    --label "${label_group}=${namespace}" >/dev/null

# to ensure ${label} is set, we use --label "${label}"
# which might overwrite the label ${label_group} of the image
docker container run \
  --init \
  --rm \
  --detach \
  --security-opt='no-new-privileges=true' \
  --publish "${http_port}:3000" \
  --network="${network_name}" \
  --name "${container_name}" \
  --label "${label}" \
  "${image_name}:${tag}" >/dev/null

readonly url="http://${host_name}:${http_port}"

printf '\nListen local: %s\n' "${url}"

if command -v pbcopy >/dev/null 2>&1; then
  printf '%s' "${url}" | pbcopy
  printf '\nThe URL has been copied to the clipboard.\n'
elif command -v xclip >/dev/null 2>&1; then
  printf '%s' "${url}" | xclip -selection clipboard
  printf '\nThe URL has been copied to the clipboard.\n'
elif command -v wl-copy >/dev/null 2>&1; then
  printf '%s' "${url}" | wl-copy
  printf '\nThe URL has been copied to the clipboard.\n'
fi
