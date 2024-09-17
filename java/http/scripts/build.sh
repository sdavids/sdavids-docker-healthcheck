#!/usr/bin/env sh

# SPDX-FileCopyrightText: © 2024 Sebastian Davids <sdavids@gmx.de>
# SPDX-License-Identifier: Apache-2.0

# javac (JDK 21+) needs to be in $PATH

set -eu

readonly base_dir="${1:-$PWD}"

if [ ! -d "${base_dir}" ]; then
  printf "The directory '%s' does not exist.\n" "${base_dir}" >&2
  exit 1
fi

readonly build_dir="${base_dir}/target/classes"

javac --release 21 -d "${build_dir}" "${base_dir}/src/HealthCheck.java"
