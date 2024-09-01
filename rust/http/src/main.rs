// SPDX-FileCopyrightText: © 2024 Sebastian Davids <sdavids@gmx.de>
// SPDX-License-Identifier: Apache-2.0

#![deny(warnings)]

use exitcode::UNAVAILABLE;
use std::env;
use std::process::exit;

use minreq::{get, Response};

// https://docs.rs/minreq/latest/minreq/index.html#timeouts-1
const TIMEOUT_S: u64 = 5;

fn main() {
  let url =
    env::var("HEALTHCHECK_URL").unwrap_or("http://localhost:3000/-/health/liveness".to_string());
  match get(url).with_timeout(TIMEOUT_S).send() {
    Ok(Response {
      status_code: 200, ..
    }) => exit(0),
    Ok(_) => exit(100),
    Err(err) => {
      eprintln!("{err}");
      exit(UNAVAILABLE)
    }
  }
}
