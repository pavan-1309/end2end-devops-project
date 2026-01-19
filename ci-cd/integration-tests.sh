#!/bin/bash

echo "🚀 Starting Integration Tests for Microservices..."

API_GATEWAY_URL="http://api-gateway:8080"
TIMEOUT=30

# Wait for services to be ready
echo "⏳ Waiting for services to be ready..."
sleep 30

# Test User Service
echo "👥 Testing User Service..."
USER_RESPONSE=$(curl -s -w "%{http_code}" -X POST \
  -H "Content-Type: application/json" \
  -d '{"name":"Test User","email":"test@example.com"}' \
  ${API_GATEWAY_URL}/api/users)

if [[ "${USER_RESPONSE: -3}" == "200" ]]; then
    echo "✅ User Service: PASS"
else
    echo "❌ User Service: FAIL (${USER_RESPONSE: -3})"
    exit 1
fi

# Test Product Service
echo "📦 Testing Product Service..."
PRODUCT_RESPONSE=$(curl -s -w "%{http_code}" -X POST \
  -H "Content-Type: application/json" \
  -d '{"name":"Test Product","description":"Test Description","price":99.99}' \
  ${API_GATEWAY_URL}/api/products)

if [[ "${PRODUCT_RESPONSE: -3}" == "200" ]]; then
    echo "✅ Product Service: PASS"
else
    echo "❌ Product Service: FAIL (${PRODUCT_RESPONSE: -3})"
    exit 1
fi

# Test API Gateway Health
echo "🌐 Testing API Gateway Health..."
GATEWAY_HEALTH=$(curl -s -w "%{http_code}" ${API_GATEWAY_URL}/actuator/health)

if [[ "${GATEWAY_HEALTH: -3}" == "200" ]]; then
    echo "✅ API Gateway Health: PASS"
else
    echo "❌ API Gateway Health: FAIL (${GATEWAY_HEALTH: -3})"
    exit 1
fi

# Test Frontend
echo "🎨 Testing Frontend..."
FRONTEND_RESPONSE=$(curl -s -w "%{http_code}" ${API_GATEWAY_URL}/)

if [[ "${FRONTEND_RESPONSE: -3}" == "200" ]]; then
    echo "✅ Frontend: PASS"
else
    echo "❌ Frontend: FAIL (${FRONTEND_RESPONSE: -3})"
    exit 1
fi

# Test Service Discovery
echo "🔍 Testing Service Discovery..."
USER_LIST=$(curl -s ${API_GATEWAY_URL}/api/users)
PRODUCT_LIST=$(curl -s ${API_GATEWAY_URL}/api/products)

if [[ "$USER_LIST" == *"Test User"* ]] && [[ "$PRODUCT_LIST" == *"Test Product"* ]]; then
    echo "✅ Service Discovery: PASS"
else
    echo "❌ Service Discovery: FAIL"
    exit 1
fi

# Test Metrics Endpoints
echo "📊 Testing Metrics Endpoints..."
USER_METRICS=$(curl -s -w "%{http_code}" ${API_GATEWAY_URL}/api/users/actuator/prometheus)
PRODUCT_METRICS=$(curl -s -w "%{http_code}" ${API_GATEWAY_URL}/api/products/actuator/prometheus)

if [[ "${USER_METRICS: -3}" == "200" ]] && [[ "${PRODUCT_METRICS: -3}" == "200" ]]; then
    echo "✅ Metrics Endpoints: PASS"
else
    echo "❌ Metrics Endpoints: FAIL"
    exit 1
fi

echo "🎉 All Integration Tests Passed!"
echo "📈 Services are healthy and communicating properly"
echo "🔗 Application URL: ${API_GATEWAY_URL}"