# Secrets Configuration

## GitHub Repository Secrets
Add these secrets in your GitHub repository settings (Settings > Secrets and variables > Actions):

### AWS Configuration
```
AWS_ACCESS_KEY_ID=your-aws-access-key
AWS_SECRET_ACCESS_KEY=your-aws-secret-key
```

### Email Notifications
```
EMAIL_USERNAME=your-gmail@gmail.com
EMAIL_PASSWORD=your-app-password
EMAIL_TO=recipient@example.com
```

## EKS Cluster Information
```
Cluster Name: observability
Region: ap-south-1
Node Type: t3.medium
Nodes: 2-3 (auto-scaling)
```

## Service URLs
```
API Gateway LoadBalancer: a356615d7820d45aba3c164573ed3c76-1845103452.ap-south-1.elb.amazonaws.com:8080
User Service: /api/users
Product Service: /api/products
Prometheus: kubectl port-forward -n monitoring svc/prometheus 9090:9090
Grafana: kubectl port-forward -n monitoring svc/grafana 3000:3000
```

## Security Groups
Ensure your EC2 security group allows:
- Port 8080-8082 (microservices)
- Port 3000-3001 (frontend/grafana)
- Port 9090 (prometheus)
- Port 22 (SSH)

## Access Commands
```bash
# Port forward all services
kubectl port-forward --address 0.0.0.0 -n dev svc/api-gateway 8080:8080 &
kubectl port-forward --address 0.0.0.0 -n monitoring svc/prometheus 9090:9090 &
kubectl port-forward --address 0.0.0.0 -n monitoring svc/grafana 3000:3000 &

# Test APIs
curl http://YOUR_EC2_IP:8080/api/users
curl http://YOUR_EC2_IP:8080/api/products
```