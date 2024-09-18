#!/usr/bin/env sh

# SPDX-FileCopyrightText: © 2024 Sebastian Davids <sdavids@gmx.de>
# SPDX-License-Identifier: Apache-2.0

set -eu

readonly port="${HEALTHCHECK_PORT:-3000}"

if nc -w 1 -z "127.0.0.1" "${port}"; then
  exit 0
fi

exit 1
