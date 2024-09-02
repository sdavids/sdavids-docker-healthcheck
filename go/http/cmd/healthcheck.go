// SPDX-FileCopyrightText: © 2024 Sebastian Davids <sdavids@gmx.de>
// SPDX-License-Identifier: Apache-2.0

package main

import (
	"log/slog"
	"net/http"
	"os"
	"runtime"
	"time"

	"github.com/dedelala/sysexits"
)

func main() {
	url, exists := os.LookupEnv("HEALTHCHECK_URL")
	if !exists {
		url = "http://localhost:3000/-/health/liveness"
	}
	client := &http.Client{
		Timeout: time.Second * 5,
	}
	res, err := client.Get(url) //nolint:noctx
	if err != nil {
		slog.Error("", slog.Any("error", err))
		os.Exit(sysexits.Unavailable)
	}
	defer func() {
		closeErr := res.Body.Close()
		if closeErr != nil {
			err = closeErr
		}
	}()
	if res.StatusCode == http.StatusOK {
		defer os.Exit(sysexits.OK)
	} else {
		defer os.Exit(100)
	}
	runtime.Goexit()
}
