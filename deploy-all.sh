#!/bin/bash

echo "🚀 Complete Microservices Deployment"

# Step 1: Cleanup
echo "🧹 Cleaning up existing deployments..."
kubectl delete deployment --all -n dev 2>/dev/null || true
kubectl delete statefulset --all -n dev 2>/dev/null || true
kubectl delete deployment --all -n monitoring 2>/dev/null || true
kubectl delete statefulset --all -n monitoring 2>/dev/null || true

# Wait for cleanup
sleep 10

# Step 2: Deploy microservices
echo "📦 Deploying microservices..."
kubectl apply -f k8s/deployment.yaml

# Step 3: Deploy monitoring
echo "📊 Deploying monitoring stack..."
kubectl apply -f k8s/monitoring.yaml

# Step 4: Wait and check status
echo "⏳ Waiting for deployments..."
sleep 30

echo "✅ Deployment Status:"
echo "📱 Microservices (dev namespace):"
kubectl get pods -n dev
echo ""
echo "📊 Monitoring (monitoring namespace):"
kubectl get pods -n monitoring
echo ""
echo "🔗 Services:"
kubectl get svc -n dev
kubectl get svc -n monitoring

echo ""
echo "🎉 Deployment completed!"
echo "📍 Access your services:"
echo "   API Gateway: kubectl port-forward -n dev svc/api-gateway 8080:8080"
echo "   Prometheus:  kubectl port-forward -n monitoring svc/prometheus 9090:9090"
echo "   Grafana:     kubectl port-forward -n monitoring svc/grafana 3000:3000"