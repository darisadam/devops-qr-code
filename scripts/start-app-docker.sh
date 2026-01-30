#!/bin/bash
set -e

echo "🚀 Starting Full Application Stack (Frontend, Backend, S3Mock)..."
echo "📦 Building and Starting Containers..."

docker-compose -f docker-compose.dev.yaml up --build -d

echo "✅ App is running!"
echo "   - Frontend: http://localhost:3000"
echo "   - Backend API: http://localhost:8000"
echo "   - S3 Mock UI: http://localhost:9090/minio/login (or API at 9090)"
echo ""
echo "📝 To view logs: docker-compose -f docker-compose.dev.yaml logs -f"
echo "🛑 To stop: docker-compose -f docker-compose.dev.yaml down"
