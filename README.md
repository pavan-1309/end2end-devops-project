# DevOps CI/CD Pipeline

Complete CI/CD pipeline using Jenkins, Docker, and Kubernetes with monitoring via Prometheus & Grafana.

## Architecture

- **Application**: Spring Boot Java app with Maven
- **CI/CD**: Jenkins pipeline
- **Containerization**: Docker
- **Orchestration**: Kubernetes
- **Monitoring**: Prometheus + Grafana

## Quick Start

### Prerequisites
- Java 11+
- Maven 3.6+
- Docker
- Kubernetes cluster
- Jenkins

### Local Development
```bash
mvn spring-boot:run
```

### Docker Build & Run
```bash
mvn package
cp target/devops-app-1.0.0.jar docker/
docker build -t devops-app docker/
docker run -p 8080:8080 devops-app
```

### Kubernetes Deployment
```bash
kubectl apply -f k8s/
kubectl apply -f monitoring/
```

### Jenkins Setup
1. Install Jenkins plugins: Docker, Kubernetes, Git
2. Configure credentials: `docker-hub`, `kubeconfig`
3. Create pipeline job using `Jenkinsfile`

## Local Development Endpoints

### Application URLs
- **Main Website**: http://localhost:8080
- **Submit Form**: http://localhost:8080/submit (POST)
- **Health Check**: http://localhost:8080/health
- **H2 Database Console**: http://localhost:8080/h2-console
  - JDBC URL: `jdbc:h2:mem:testdb`
  - Username: `sa`
  - Password: (leave empty)

### Monitoring URLs
- **Prometheus**: http://localhost:9090
- **Grafana**: http://localhost:3000 (admin/admin)
- **App Metrics**: http://localhost:8080/actuator/prometheus
- **Spring Boot Actuator**: http://localhost:8080/actuator/health

## Pipeline Stages

1. **Checkout**: Git source code
2. **Build**: Maven compile
3. **Test**: Unit tests with JUnit
4. **Package**: Create JAR file
5. **Docker Build**: Container image
6. **Docker Push**: Registry upload
7. **Deploy**: Kubernetes deployment

## Endpoints

### Web Application
- `/` - Dynamic website with form and message display
- `/submit` - Form submission endpoint (POST)
- `/health` - Simple health check

### Database Access
- `/h2-console` - H2 database web console (local only)

### Spring Boot Actuator
- `/actuator/health` - Detailed health information
- `/actuator/prometheus` - Metrics for Prometheus monitoring
- `/actuator/info` - Application information