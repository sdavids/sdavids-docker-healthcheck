#!/usr/bin/env sh

# SPDX-FileCopyrightText: © 2024 Sebastian Davids <sdavids@gmx.de>
# SPDX-License-Identifier: Apache-2.0

# script needs to be invoked from the project's root directory

set -eu

readonly base_dir="$PWD"

rust/http/scripts/lint.sh "${base_dir}/rust/http"
rust/https/scripts/lint.sh "${base_dir}/rust/https"
shell/nc/scripts/lint.sh "${base_dir}/shell/nc"
