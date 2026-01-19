#!/bin/bash

echo "🚀 Deploying Microservices to Dev Namespace..."

# Deploy microservices to dev namespace
echo "📦 Deploying microservices..."
kubectl apply -f k8s/deployment.yaml

# Apply ServiceMonitors for cross-namespace monitoring
echo "📊 Setting up monitoring..."
kubectl apply -f k8s/monitoring/servicemonitor.yaml

# Wait for deployments
echo "⏳ Waiting for deployments to be ready..."
kubectl rollout status deployment/user-service -n dev
kubectl rollout status deployment/product-service -n dev
kubectl rollout status deployment/api-gateway -n dev
kubectl rollout status deployment/frontend -n dev

# Get service URLs
echo "🔗 Getting service URLs..."
kubectl get services -n dev

echo "✅ Microservices deployed successfully in dev namespace!"
echo "🔍 Monitor at: kubectl port-forward -n monitoring svc/prometheus-stack-kube-prom-prometheus 9090:9090"