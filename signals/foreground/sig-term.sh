#!/usr/bin/env bash
set -ex

# gracefully stop the app
docker kill --signal="SIGTERM" signal-fg-app

# or
# docker stop signal-fg-app
