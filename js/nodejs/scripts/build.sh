#!/usr/bin/env sh

# SPDX-FileCopyrightText: © 2024 Sebastian Davids <sdavids@gmx.de>
# SPDX-License-Identifier: Apache-2.0

set -eu

readonly base_dir="${1:-$PWD}"

if [ ! -d "${base_dir}" ]; then
  printf "The directory '%s' does not exist.\n" "${base_dir}" >&2
  exit 1
fi

# https://compat-table.github.io/compat-table/es2016plus/#node22_0
readonly esbuild_target="${1:-es2024}"

readonly dir="${base_dir}/dist"

rm -rf "${dir}"

if [ ! -d 'node_modules' ]; then
  npm ci --silent --ignore-scripts=true --fund=false
fi

npx --yes --quiet \
  esbuild "${base_dir}/src/server.mjs" \
  --bundle \
  --platform=node \
  --target="${esbuild_target}" \
  --format=esm \
  --minify \
  --legal-comments=none \
  --outdir="${dir}" \
  --out-extension:.js=.mjs

npx --yes --quiet \
  esbuild "${base_dir}/src/healthcheck.mjs" \
  --bundle \
  --platform=node \
  --target="${esbuild_target}" \
  --format=esm \
  --minify \
  --legal-comments=none \
  --outdir="${dir}" \
  --out-extension:.js=.mjs
