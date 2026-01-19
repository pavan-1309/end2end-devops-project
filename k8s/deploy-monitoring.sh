#!/bin/bash

echo "🚀 Deploying Observability Stack to Kubernetes..."

# Create namespaces
echo "📁 Creating namespaces..."
kubectl apply -f k8s/namespaces/

# Add Helm repositories
echo "📦 Adding Helm repositories..."
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# Install Prometheus Stack with minimal configuration
echo "📊 Installing Prometheus Stack..."
helm upgrade --install prometheus-stack prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --set prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.resources.requests.storage=5Gi \
  --set grafana.persistence.enabled=false \
  --set alertmanager.alertmanagerSpec.storage.volumeClaimTemplate.spec.resources.requests.storage=2Gi \
  --timeout 10m \
  --wait

if [ $? -eq 0 ]; then
    echo "✅ Monitoring stack deployed successfully!"
    
    # Get service URLs
    echo "🔗 Getting service URLs..."
    echo "Prometheus: kubectl port-forward -n monitoring svc/prometheus-stack-kube-prom-prometheus 9090:9090"
    echo "Grafana: kubectl port-forward -n monitoring svc/prometheus-stack-grafana 3000:80"
    echo "AlertManager: kubectl port-forward -n monitoring svc/prometheus-stack-kube-prom-alertmanager 9093:9093"
else
    echo "❌ Monitoring stack deployment failed, installing basic Prometheus..."
    
    # Fallback to basic Prometheus
    kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: prometheus
  namespace: monitoring
spec:
  replicas: 1
  selector:
    matchLabels:
      app: prometheus
  template:
    metadata:
      labels:
        app: prometheus
    spec:
      containers:
      - name: prometheus
        image: prom/prometheus:latest
        ports:
        - containerPort: 9090
---
apiVersion: v1
kind: Service
metadata:
  name: prometheus
  namespace: monitoring
spec:
  selector:
    app: prometheus
  ports:
  - port: 9090
    targetPort: 9090
EOF
    
    echo "✅ Basic Prometheus deployed!"
fi