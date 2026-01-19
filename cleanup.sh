#!/bin/bash

echo "🧹 Cleaning up unnecessary pods and deployments..."

# Delete all deployments and statefulsets in dev namespace
kubectl delete deployment --all -n dev
kubectl delete statefulset --all -n dev
kubectl delete pod --all -n dev

# Delete problematic Prometheus components in monitoring namespace
kubectl delete statefulset prometheus-prometheus-stack-kube-prom-prometheus -n monitoring
kubectl delete statefulset alertmanager-prometheus-stack-kube-prom-alertmanager -n monitoring
kubectl delete pod --all -n monitoring

echo "✅ Cleanup completed!"
echo "📊 Remaining pods:"
kubectl get pods -n dev
kubectl get pods -n monitoring