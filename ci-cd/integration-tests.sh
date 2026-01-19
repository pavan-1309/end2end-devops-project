#!/bin/bash

echo "🚀 Starting Integration Tests for Microservices..."

# Get service URLs from kubectl
API_GATEWAY_URL=$(kubectl get svc api-gateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}' 2>/dev/null || echo "localhost")
if [ "$API_GATEWAY_URL" = "localhost" ]; then
    # Use port-forward for local testing
    kubectl port-forward svc/api-gateway 8080:8080 &
    PORT_FORWARD_PID=$!
    API_GATEWAY_URL="http://localhost:8080"
    sleep 10
else
    API_GATEWAY_URL="http://$API_GATEWAY_URL:8080"
fi

echo "📍 Testing against: $API_GATEWAY_URL"

# Wait for services to be ready
echo "⏳ Waiting for services to be ready..."
sleep 30

# Test API Gateway Health first
echo "🌐 Testing API Gateway Health..."
for i in {1..10}; do
    GATEWAY_HEALTH=$(curl -s -w "%{http_code}" $API_GATEWAY_URL/actuator/health 2>/dev/null || echo "000")
    if [[ "${GATEWAY_HEALTH: -3}" == "200" ]]; then
        echo "✅ API Gateway Health: PASS"
        break
    else
        echo "⏳ Attempt $i: Gateway not ready (${GATEWAY_HEALTH: -3})"
        sleep 5
    fi
    if [ $i -eq 10 ]; then
        echo "❌ API Gateway Health: FAIL - Service not accessible"
        [ ! -z "$PORT_FORWARD_PID" ] && kill $PORT_FORWARD_PID
        exit 1
    fi
done

# Test User Service
echo "👥 Testing User Service..."
USER_RESPONSE=$(curl -s -w "%{http_code}" -X GET $API_GATEWAY_URL/api/users 2>/dev/null || echo "000")

if [[ "${USER_RESPONSE: -3}" == "200" ]]; then
    echo "✅ User Service: PASS"
else
    echo "❌ User Service: FAIL (${USER_RESPONSE: -3})"
    [ ! -z "$PORT_FORWARD_PID" ] && kill $PORT_FORWARD_PID
    exit 1
fi

# Test Product Service
echo "📦 Testing Product Service..."
PRODUCT_RESPONSE=$(curl -s -w "%{http_code}" -X GET $API_GATEWAY_URL/api/products 2>/dev/null || echo "000")

if [[ "${PRODUCT_RESPONSE: -3}" == "200" ]]; then
    echo "✅ Product Service: PASS"
else
    echo "❌ Product Service: FAIL (${PRODUCT_RESPONSE: -3})"
    [ ! -z "$PORT_FORWARD_PID" ] && kill $PORT_FORWARD_PID
    exit 1
fi

echo "🎉 All Integration Tests Passed!"
echo "📈 Services are healthy and communicating properly"
echo "🔗 Application URL: $API_GATEWAY_URL"

# Cleanup
[ ! -z "$PORT_FORWARD_PID" ] && kill $PORT_FORWARD_PID