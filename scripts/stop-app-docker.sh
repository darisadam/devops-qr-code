#!/bin/bash
echo "🛑 Stopping Full Application Stack (Dev Mode)..."
docker-compose -f docker-compose.dev.yaml down
echo "✅ Application Stack stopped."
