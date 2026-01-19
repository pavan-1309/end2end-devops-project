#!/bin/bash

echo "🚀 Deploying Microservices to EKS..."

# Delete existing deployments
kubectl delete deployment --all -n dev 2>/dev/null || true
kubectl delete deployment --all -n monitoring 2>/dev/null || true

# Apply simple deployments
kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: user-service
  namespace: dev
spec:
  replicas: 1
  selector:
    matchLabels:
      app: user-service
  template:
    metadata:
      labels:
        app: user-service
    spec:
      containers:
      - name: user-service
        image: nginx:alpine
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: user-service
  namespace: dev
spec:
  selector:
    app: user-service
  ports:
  - port: 8081
    targetPort: 80
---
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

echo "✅ Deployment completed!"
kubectl get pods -n dev
kubectl get pods -n monitoring