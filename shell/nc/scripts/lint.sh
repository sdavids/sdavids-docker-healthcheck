#!/usr/bin/env sh

# SPDX-FileCopyrightText: © 2024 Sebastian Davids <sdavids@gmx.de>
# SPDX-License-Identifier: Apache-2.0

# _shellcheck needs to be in $PATH
# https://www.shellcheck.net
#   Mac:
#     brew install shellcheck
#   Linux:
#     sudo apt-get install shellcheck

set -eu

readonly base_dir="${1:-$PWD}"

if [ ! -d "${base_dir}" ]; then
  printf "The directory '%s' does not exist.\n" "${base_dir}" >&2
  exit 1
fi

find "${base_dir}" -type f -name '*.sh' -print0 | xargs -0L1 shellcheck
