#!/bin/bash
echo "🛑 Stopping Local Infrastructure Stack (LocalStack)..."
docker-compose -f docker-compose.yaml down
echo "✅ Infrastructure Stack stopped."
