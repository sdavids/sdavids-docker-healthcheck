#!/usr/bin/env sh

# SPDX-FileCopyrightText: © 2024 Sebastian Davids <sdavids@gmx.de>
# SPDX-License-Identifier: Apache-2.0

set -eu

readonly base_dir="${1:-$PWD}"

readonly eslint_cache_dir="${base_dir}/node_modules/.cache/eslint"
readonly prettier_cache_dir="${base_dir}/node_modules/.cache/prettier"

rm -rf "${eslint_cache_dir}" \
  "${prettier_cache_dir}"
