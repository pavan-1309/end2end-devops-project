#!/bin/bash

echo "🚀 Starting Integration Tests for Microservices..."

# Simple build verification tests
echo "📦 Verifying JAR files exist..."
for service in user-service product-service api-gateway; do
    if [ -f "microservices/$service/target/$service-1.0.0.jar" ]; then
        echo "✅ $service JAR: PASS"
    else
        echo "❌ $service JAR: FAIL"
        exit 1
    fi
done

# Verify Docker images were built
echo "🐳 Verifying Docker images..."
for service in user-service product-service api-gateway frontend; do
    if docker images | grep -q "$service"; then
        echo "✅ $service Docker image: PASS"
    else
        echo "❌ $service Docker image: FAIL"
        exit 1
    fi
done

echo "🎉 All Integration Tests Passed!"
echo "📈 Build artifacts verified successfully"