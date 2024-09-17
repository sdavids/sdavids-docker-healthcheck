#!/usr/bin/env sh

# SPDX-FileCopyrightText: © 2024 Sebastian Davids <sdavids@gmx.de>
# SPDX-License-Identifier: Apache-2.0

# native-image (GraalVM) needs to be in $PATH

set -eu

readonly base_dir="${1:-$PWD}"

if [ ! -d "${base_dir}" ]; then
  printf "The directory '%s' does not exist.\n" "${base_dir}" >&2
  exit 1
fi

readonly bin_name='healthcheck'

readonly build_classes_dir="${base_dir}/target/classes"
readonly build_native_dir="${base_dir}/target/native"

readonly class_name='HealthCheck'
readonly class_file_path="${build_classes_dir}/${class_name}.class"

if [ ! -f "${class_file_path}" ]; then
  echo "'${class_file_path}' does not exist; execute the build.sh script" >&2
  exit 1
fi

mkdir -p "${build_native_dir}"

# https://www.graalvm.org/latest/reference-manual/native-image/overview/BuildOutput/#recommendations
# -0b for smaller size
# --gc=epsilon because we are a short-lived process
native-image \
  -march=native \
  -Ob \
  --gc=epsilon \
  --initialize-at-build-time="${class_name}" \
  --install-exit-handlers \
  --enable-http \
  -cp "${build_classes_dir}" \
  -o "${build_native_dir}/${bin_name}" \
  "${class_name}"
