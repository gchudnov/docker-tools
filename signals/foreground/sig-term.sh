#!/usr/bin/env bash
set -ex

# gracefully stop the app
docker kill --signal="SIGTERM" signal-fg-app
