#!/usr/bin/env sh

# SPDX-FileCopyrightText: © 2024 Sebastian Davids <sdavids@gmx.de>
# SPDX-License-Identifier: Apache-2.0

# script needs to be invoked from the project's root directory

set -eu

readonly base_dir="$PWD"

js/nodejs/scripts/dependency_check_node.sh "${base_dir}/js/nodejs"
rust/http/scripts/dependency_check_rust.sh "${base_dir}/rust/http"
rust/https/scripts/dependency_check_rust.sh "${base_dir}/rust/https"
