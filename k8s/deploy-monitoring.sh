#!/bin/bash

echo "🚀 Deploying Observability Stack to Kubernetes..."

# Create namespaces
echo "📁 Creating namespaces..."
kubectl apply -f k8s/namespaces/

# Add Helm repositories
echo "📦 Adding Helm repositories..."
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# Install Prometheus Stack in monitoring namespace
echo "📊 Installing Prometheus Stack..."
helm upgrade --install prometheus-stack prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --values k8s/helm/prometheus-values.yaml \
  --wait

# Wait for pods to be ready
echo "⏳ Waiting for monitoring stack to be ready..."
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=prometheus --namespace monitoring --timeout=300s
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=grafana --namespace monitoring --timeout=300s

# Get service URLs
echo "🔗 Getting service URLs..."
echo "Prometheus: kubectl port-forward -n monitoring svc/prometheus-stack-kube-prom-prometheus 9090:9090"
echo "Grafana: kubectl port-forward -n monitoring svc/prometheus-stack-grafana 3000:80"
echo "AlertManager: kubectl port-forward -n monitoring svc/prometheus-stack-kube-prom-alertmanager 9093:9093"

echo "✅ Monitoring stack deployed successfully!"