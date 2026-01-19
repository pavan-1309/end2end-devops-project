#!/bin/bash

echo "🚀 Deploying Working Microservices Application..."

# Clean up existing deployments
echo "🧹 Cleaning up..."
kubectl delete deployment --all -n dev 2>/dev/null || true
kubectl delete configmap --all -n dev 2>/dev/null || true
kubectl delete service --all -n dev 2>/dev/null || true

# Wait for cleanup
sleep 5

# Deploy the working application
echo "📦 Deploying microservices..."
kubectl apply -f k8s/working-deployment.yaml

# Wait for deployments
echo "⏳ Waiting for pods to be ready..."
kubectl wait --for=condition=ready pod -l app=user-service -n dev --timeout=60s
kubectl wait --for=condition=ready pod -l app=product-service -n dev --timeout=60s
kubectl wait --for=condition=ready pod -l app=api-gateway -n dev --timeout=60s
kubectl wait --for=condition=ready pod -l app=frontend -n dev --timeout=60s

echo "✅ Deployment completed!"
echo ""
echo "📊 Pod Status:"
kubectl get pods -n dev
echo ""
echo "🔗 Services:"
kubectl get svc -n dev
echo ""
echo "🌐 Access your application:"
echo "   LoadBalancer URL: $(kubectl get svc api-gateway -n dev -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'):8080"
echo "   Or use port-forward: kubectl port-forward --address 0.0.0.0 -n dev svc/api-gateway 8080:8080"
echo ""
echo "🧪 Test endpoints:"
echo "   curl http://YOUR_IP:8080/api/users"
echo "   curl http://YOUR_IP:8080/api/products"