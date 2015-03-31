#!/usr/bin/env bash
set -ex

docker run -it --rm -p 3000:3000 --name="signal-fg-app" signal-fg-app
