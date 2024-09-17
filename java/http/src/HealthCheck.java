/*
 * SPDX-FileCopyrightText: © 2024 Sebastian Davids <sdavids@gmx.de>
 * SPDX-License-Identifier: Apache-2.0
 */
import static java.lang.System.getenv;
import static java.net.HttpURLConnection.HTTP_OK;
import static java.util.Objects.requireNonNullElse;

import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URI;
import java.net.URL;

public class HealthCheck {
  public static void main(String[] args) {
    var u =
        requireNonNullElse(getenv("HEALTHCHECK_URL"), "http://localhost:3000/-/health/liveness");

    URL url = null;
    try {
      url = URI.create(u).toURL();
    } catch (IllegalArgumentException | MalformedURLException e) {
      System.err.printf("'%s' is not a valid URL%n", u);
      System.exit(64); // EX_USAGE
    }

    try {
      var connection = (HttpURLConnection) url.openConnection();
      connection.setConnectTimeout(5000);
      connection.setReadTimeout(5000);

      connection.disconnect();

      System.exit(connection.getResponseCode() == HTTP_OK ? 0 : 100);
    } catch (IOException e) {
      System.err.printf("%s%n", u);
      e.printStackTrace();
      System.exit(70); // EX_SOFTWARE
    }
  }
}
