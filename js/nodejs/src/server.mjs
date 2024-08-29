// SPDX-FileCopyrightText: © 2024 Sebastian Davids <sdavids@gmx.de>
// SPDX-License-Identifier: Apache-2.0

import { readFileSync } from 'node:fs';
import process from 'node:process';

['uncaughtException', 'unhandledRejection'].forEach((s) =>
  process.once(s, (e) => {
    console.error(e);
    process.exit(70); // EX_SOFTWARE
  }),
);
['SIGINT', 'SIGTERM'].forEach((s) => process.once(s, () => process.exit(0)));

const port = 3000;

let options = {};
// eslint-disable-next-line init-declarations
let engine;
try {
  const key = readFileSync('key.pem');
  const cert = readFileSync('cert.pem');
  try {
    engine = await import('node:https');
  } catch {
    console.error('https support is disabled');
    process.exit(78); // EX_CONFIG
  }
  options = {
    key,
    cert,
  };
} catch {
  engine = await import('node:http');
}

const server = engine.createServer(options, ({ url }, res) => {
  if (url === '/' || url === '/index.html') {
    res
      .writeHead(200)
      .end(
        '<!doctype html><title>sdavids-docker-healthcheck-js-nodejs</title><h1>sdavids-docker-healthcheck-js-nodejs</h1>',
      );
  } else if (url === '/-/health/liveness') {
    res.writeHead(200).end('{}');
  } else {
    res.writeHead(404).end('Not found');
  }
});
server.keepAliveTimeout = 5000;
server.requestTimeout = 5000;
server.timeout = 5000;
server.listen(port);

console.log(
  `Listen local: http${Object.hasOwn(options, 'key') ? 's' : ''}://localhost:${port}`,
);
