#!/bin/bash
set -e

echo "🔹 Checking dependencies..."
if ! command -v tflocal &> /dev/null; then
    echo "❌ tflocal could not be found. Please install it with: pip install terraform-local"
    exit 1
fi

echo "🔹 Starting LocalStack..."
docker-compose up -d localstack
echo "⏳ Waiting for LocalStack to be ready..."
sleep 5

echo "🔹 Bootstrapping Remote State (S3 + DynamoDB) in LocalStack..."
# We run the bootstrap terraform against LocalStack to create the buckets/tables
cd infrastructure/bootstrap
tflocal init
tflocal apply -auto-approve
cd ../..

echo "🔹 Initializing Main Infrastructure in LocalStack..."
cd infrastructure
tflocal init

echo "🔹 Planning Main Infrastructure..."
# We run 'plan' because 'apply' for EKS can be problematic on LocalStack Community/Free
tflocal plan

echo "✅  Plan verification complete! If you want to try applying, run 'cd infrastructure && tflocal apply'"
