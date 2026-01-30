#!/bin/bash

# Wrapper to stop EVERYTHING
./scripts/stop-app-docker.sh
./scripts/stop-local-infra.sh

echo "✅ All local environments stopped."
