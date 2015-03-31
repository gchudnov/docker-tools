#!/usr/bin/env bash
set -ex

# invoke SIGUSR1
docker kill --signal="SIGUSR1" signal-bg-app
