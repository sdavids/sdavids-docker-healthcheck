#!/usr/bin/env sh

# SPDX-FileCopyrightText: © 2024 Sebastian Davids <sdavids@gmx.de>
# SPDX-License-Identifier: Apache-2.0

# script needs to be invoked from the project's root directory

set -eu

readonly base_dir="$PWD"

go/http/scripts/format.sh "${base_dir}/go/http"
go/https/scripts/format.sh "${base_dir}/go/https"
java/http/scripts/format.sh "${base_dir}/java/http"
js/nodejs/scripts/format.sh "${base_dir}/js/nodejs"
rust/http/scripts/format.sh "${base_dir}/rust/http"
rust/https/scripts/format.sh "${base_dir}/rust/https"
shell/nc/scripts/format.sh "${base_dir}/shell/nc"
