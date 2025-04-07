// SPDX-FileCopyrightText: © 2024 Sebastian Davids <sdavids@gmx.de>
// SPDX-License-Identifier: Apache-2.0

package main

import (
	"cmp"
	"io"
	"log/slog"
	"net/http"
	"os"
	"runtime"
	"time"
)

func main() {
	url := cmp.Or(os.Getenv("HEALTHCHECK_URL"), "http://localhost:3000/-/health/liveness")
	client := &http.Client{
		Timeout: time.Second * 5,
	}
	res, err := client.Get(url) //nolint
	if err != nil {
		slog.Error("", slog.Any("error", err))
		os.Exit(69) // EX_UNAVAILABLE
	}
	defer func(Body io.ReadCloser) {
		_ = Body.Close()
	}(res.Body)
	if res.StatusCode == http.StatusOK {
		defer os.Exit(0) // EX_OK
	} else {
		defer os.Exit(100)
	}
	runtime.Goexit()
}
