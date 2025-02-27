// SPDX-FileCopyrightText: © 2024 Sebastian Davids <sdavids@gmx.de>
// SPDX-License-Identifier: Apache-2.0

#![deny(warnings)]

use exitcode::{CONFIG, UNAVAILABLE};
use minreq::Error::HttpsFeatureNotEnabled;
use minreq::{Response, get};
use std::env;
use std::process::exit;

// https://docs.rs/minreq/latest/minreq/index.html#timeouts-1
const TIMEOUT_S: u64 = 5;

fn main() {
  let url =
    env::var("HEALTHCHECK_URL").unwrap_or("https://localhost:3000/-/health/liveness".to_string());
  match get(url).with_timeout(TIMEOUT_S).send() {
    Ok(Response {
      status_code: 200, ..
    }) => exit(0),
    Ok(_) => exit(100),
    Err(HttpsFeatureNotEnabled) => exit(CONFIG),
    Err(err) => {
      eprintln!("{err}");
      exit(UNAVAILABLE)
    }
  }
}
