# Microservices DevOps Pipeline

Complete microservices architecture with comprehensive DevOps pipeline including GitHub Actions, Docker, Kubernetes, and monitoring.

## Architecture

- **Microservices**: User Service, Product Service, API Gateway, Frontend
- **CI/CD**: GitHub Actions with comprehensive pipeline
- **Containerization**: Docker with multi-stage builds
- **Orchestration**: AWS EKS with auto-scaling
- **Monitoring**: Prometheus + Grafana
- **Security**: Trivy image scanning
- **Infrastructure**: AWS EKS cluster in ap-south-1

## Services

### User Service (Port 8081)
- REST API for user management
- Endpoints: GET/POST/PUT/DELETE /api/users
- Health check: /api/users/health
- Spring Boot with JPA

### Product Service (Port 8082)
- REST API for product management
- Endpoints: GET/POST/PUT/DELETE /api/products
- Health check: /api/products/health
- Spring Boot with JPA

### API Gateway (Port 8080)
- Nginx-based reverse proxy
- Routes traffic to microservices
- LoadBalancer service type
- CORS configuration

### Frontend (Port 3000)
- Interactive web dashboard
- Service health monitoring
- Real-time API testing
- Responsive design

## Quick Start

### Prerequisites
- AWS CLI configured
- kubectl installed
- EKS cluster running

### Deploy to EKS
```bash
# Deploy working application
chmod +x deploy-working.sh
./deploy-working.sh

# Access via LoadBalancer
echo "http://$(kubectl get svc api-gateway -n dev -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'):8080"

# Or use port-forwarding
kubectl port-forward --address 0.0.0.0 -n dev svc/api-gateway 8080:8080
```

## Application URLs

### Production (EKS LoadBalancer)
- **Frontend Dashboard**: http://a356615d7820d45aba3c164573ed3c76-1845103452.ap-south-1.elb.amazonaws.com:8080
- **User API**: http://a356615d7820d45aba3c164573ed3c76-1845103452.ap-south-1.elb.amazonaws.com:8080/api/users
- **Product API**: http://a356615d7820d45aba3c164573ed3c76-1845103452.ap-south-1.elb.amazonaws.com:8080/api/products

### Development (Port Forward)
- **Frontend Dashboard**: http://YOUR_EC2_IP:8080
- **User Service**: http://YOUR_EC2_IP:8081/api/users
- **Product Service**: http://YOUR_EC2_IP:8082/api/products
- **Prometheus**: http://YOUR_EC2_IP:9090
- **Grafana**: http://YOUR_EC2_IP:3000

## CI/CD Pipeline Stages

1. **Checkout**: Git source code
2. **Build**: Maven compile (parallel)
3. **Test**: Unit tests with JUnit
4. **Package**: Create JAR files
5. **Docker Build**: Container images (local)
6. **Deploy to EKS**: Rolling deployment
7. **Integration Tests**: End-to-end testing
8. **Email Notification**: Success/failure alerts

## EKS Cluster Configuration

```bash
# Cluster Details
Cluster Name: observability
Region: ap-south-1
Zones: ap-south-1a, ap-south-1b
Node Type: t3.medium
Nodes: 2-3 (managed, auto-scaling)

# Created with:
eksctl create cluster --name=observability \
  --region=ap-south-1 \
  --zones=ap-south-1a,ap-south-1b \
  --without-nodegroup

eksctl create nodegroup --cluster=observability \
  --region=ap-south-1 \
  --name=observability-ng-private \
  --node-type=t3.medium \
  --nodes-min=2 \
  --nodes-max=3 \
  --managed
```

## Monitoring & Observability

### Prometheus Metrics
- Application health status
- HTTP request metrics
- Custom business metrics
- Kubernetes cluster metrics

### Grafana Dashboards
- Microservices overview
- Individual service metrics
- Infrastructure monitoring

### Access Monitoring
```bash
# Prometheus
kubectl port-forward --address 0.0.0.0 -n monitoring svc/prometheus 9090:9090

# Grafana (admin/admin)
kubectl port-forward --address 0.0.0.0 -n monitoring svc/grafana 3000:3000
```

## API Endpoints

### User Service API
- `GET /api/users` - List all users
- `POST /api/users` - Create user
- `GET /api/users/{id}` - Get user by ID
- `PUT /api/users/{id}` - Update user
- `DELETE /api/users/{id}` - Delete user
- `GET /api/users/health` - Health check

### Product Service API
- `GET /api/products` - List all products
- `POST /api/products` - Create product
- `GET /api/products/{id}` - Get product by ID
- `PUT /api/products/{id}` - Update product
- `DELETE /api/products/{id}` - Delete product
- `GET /api/products/health` - Health check

## Development Workflow

1. **Code**: Develop features in microservices
2. **Commit**: Push to GitHub repository
3. **Pipeline**: GitHub Actions automatically triggers
4. **Build**: Compile and test all services
5. **Deploy**: Automatic deployment to EKS
6. **Monitor**: Prometheus/Grafana observability
7. **Alert**: Email notifications on failure

## Deployment Commands

```bash
# Deploy everything
./deploy-working.sh

# Clean up
kubectl delete deployment --all -n dev
kubectl delete deployment --all -n monitoring

# Check status
kubectl get pods -n dev
kubectl get svc -n dev

# Port forward services
kubectl port-forward --address 0.0.0.0 -n dev svc/api-gateway 8080:8080 &
kubectl port-forward --address 0.0.0.0 -n monitoring svc/prometheus 9090:9090 &

# Stop port forwards
pkill -f "kubectl port-forward"
```

## Security

- **Container Scanning**: Trivy security scanning (disabled due to registry issues)
- **Network Policies**: Kubernetes network segmentation
- **RBAC**: Role-based access control
- **Secrets Management**: GitHub Secrets for sensitive data

## Troubleshooting

### Common Issues
- **ImagePullBackOff**: Using local builds, no registry required
- **Pending Pods**: Check node resources and storage
- **Service Unreachable**: Verify service and endpoint configuration

### Debug Commands
```bash
# Check pod logs
kubectl logs -l app=user-service -n dev

# Describe pod issues
kubectl describe pod POD_NAME -n dev

# Check service endpoints
kubectl get endpoints -n dev

# Test service connectivity
kubectl exec -it POD_NAME -n dev -- curl http://user-service:8081/api/users
```

This architecture provides a complete, production-ready microservices platform with comprehensive DevOps practices, monitoring, and AWS EKS deployment.