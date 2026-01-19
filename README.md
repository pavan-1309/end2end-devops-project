# Microservices DevOps Pipeline

Complete microservices architecture with comprehensive DevOps pipeline including Jenkins, Docker, Kubernetes, monitoring, security scanning, and quality analysis.

## Architecture

- **Microservices**: User Service, Product Service, API Gateway, Frontend
- **CI/CD**: Jenkins with comprehensive pipeline
- **Containerization**: Docker with multi-stage builds
- **Orchestration**: Kubernetes with auto-scaling
- **Monitoring**: Prometheus + Grafana + AlertManager
- **Security**: OWASP dependency check, Trivy image scanning
- **Quality**: SonarQube code analysis
- **Registry**: Sonatype Nexus repository

## Services

### User Service (Port 8081)
- REST API for user management
- H2 database (dev) / MySQL (prod)
- Prometheus metrics
- Health checks

### Product Service (Port 8082)
- REST API for product management
- H2 database (dev) / MySQL (prod)
- Prometheus metrics
- Health checks

### API Gateway (Port 8080)
- Spring Cloud Gateway
- Routes traffic to microservices
- CORS configuration
- Load balancing

### Frontend (Port 3000)
- Dynamic web interface
- Service health monitoring
- Real-time data display
- Responsive design

## Quick Start

### Prerequisites
- Java 11+
- Maven 3.6+
- Docker & Docker Compose
- Kubernetes cluster
- Jenkins

### Local Development
```bash
# Start individual services
cd microservices/user-service && mvn spring-boot:run
cd microservices/product-service && mvn spring-boot:run
cd microservices/api-gateway && mvn spring-boot:run
```

### Docker Compose (Complete Stack)
```bash
docker-compose up -d
```

### Kubernetes Deployment
```bash
kubectl apply -f k8s/
kubectl apply -f monitoring/
```

## Local Development Endpoints

### Application URLs
- **Frontend Dashboard**: http://localhost:3000
- **API Gateway**: http://localhost:8080
- **User Service**: http://localhost:8081/api/users
- **Product Service**: http://localhost:8082/api/products

### Monitoring URLs
- **Prometheus**: http://localhost:9090
- **Grafana**: http://localhost:3001 (admin/admin)
- **AlertManager**: http://localhost:9093

### DevOps Tools
- **SonarQube**: http://localhost:9000 (admin/admin)
- **Nexus Repository**: http://localhost:8081 (admin/admin123)

### Health Checks
- **User Service Health**: http://localhost:8081/actuator/health
- **Product Service Health**: http://localhost:8082/actuator/health
- **API Gateway Health**: http://localhost:8080/actuator/health

### Metrics Endpoints
- **User Service Metrics**: http://localhost:8081/actuator/prometheus
- **Product Service Metrics**: http://localhost:8082/actuator/prometheus
- **API Gateway Metrics**: http://localhost:8080/actuator/prometheus

## CI/CD Pipeline Stages

1. **Checkout**: Git source code
2. **Build**: Maven compile (parallel)
3. **Test**: Unit tests with JUnit
4. **SonarQube**: Code quality analysis
5. **OWASP**: Dependency vulnerability scan
6. **Package**: Create JAR files
7. **Docker Build**: Container images
8. **Trivy Scan**: Image security scanning
9. **Push to Nexus**: Artifact repository
10. **Deploy to K8s**: Rolling deployment
11. **Integration Tests**: End-to-end testing

## Security & Quality Tools

### SonarQube Analysis
```bash
mvn sonar:sonar -Dsonar.projectKey=microservices
```

### OWASP Dependency Check
```bash
mvn org.owasp:dependency-check-maven:check
```

### Trivy Image Scanning
```bash
trivy image your-image:tag
```

## Monitoring & Alerting

### Prometheus Metrics
- Application metrics (HTTP requests, response times)
- JVM metrics (memory, CPU, garbage collection)
- Custom business metrics
- Kubernetes cluster metrics

### Grafana Dashboards
- Microservices overview
- Individual service metrics
- Infrastructure monitoring
- Alert status

### AlertManager Rules
- Service down alerts
- High memory/CPU usage
- Error rate thresholds
- Response time alerts
- Database connection failures

## API Endpoints

### User Service API
- `GET /api/users` - List all users
- `POST /api/users` - Create user
- `GET /api/users/{id}` - Get user by ID
- `PUT /api/users/{id}` - Update user
- `DELETE /api/users/{id}` - Delete user

### Product Service API
- `GET /api/products` - List all products
- `POST /api/products` - Create product
- `GET /api/products/{id}` - Get product by ID
- `PUT /api/products/{id}` - Update product
- `DELETE /api/products/{id}` - Delete product

## Development Workflow

1. **Code**: Develop features in microservices
2. **Test**: Run unit tests locally
3. **Commit**: Push to Git repository
4. **Pipeline**: Jenkins automatically triggers
5. **Quality**: SonarQube analysis
6. **Security**: OWASP & Trivy scans
7. **Deploy**: Automatic deployment to K8s
8. **Monitor**: Prometheus/Grafana observability
9. **Alert**: Automated notifications

## Production Deployment

### Environment Variables
```bash
SPRING_PROFILES_ACTIVE=prod
DOCKER_REGISTRY=your-nexus-repo:8082
SONAR_HOST=http://sonarqube:9000
NEXUS_REPO=http://nexus:8081
```

### Kubernetes Scaling
```bash
kubectl scale deployment user-service --replicas=5
kubectl scale deployment product-service --replicas=5
```

This architecture provides a complete, production-ready microservices platform with comprehensive DevOps practices, monitoring, security, and quality assurance.