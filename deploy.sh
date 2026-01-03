#!/bin/bash

echo "Deploying DevOps Application to Kubernetes..."

# Apply application manifests
kubectl apply -f k8s/

# Apply monitoring manifests
kubectl apply -f monitoring/prometheus-k8s.yaml
kubectl apply -f monitoring/grafana-k8s.yaml

# Wait for deployments
echo "Waiting for deployments to be ready..."
kubectl rollout status deployment/devops-app
kubectl rollout status deployment/prometheus
kubectl rollout status deployment/grafana

# Get service URLs
echo "Getting service URLs..."
kubectl get services

echo "Deployment complete!"
echo "Access your application at: http://localhost:8080"
echo "Access Prometheus at: http://localhost:9090"
echo "Access Grafana at: http://localhost:3000 (admin/admin)"