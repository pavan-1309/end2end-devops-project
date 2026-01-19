# GitHub Secrets Configuration

This document lists all the secrets required for the CI/CD pipeline to work properly.

## Required Secrets

Navigate to: **Repository Settings → Secrets and Variables → Actions → New repository secret**

### 1. SonarQube Integration
```
SONAR_TOKEN
```
- **Description**: SonarQube authentication token for code quality analysis
- **How to get**: 
  - Login to SonarQube → My Account → Security → Generate Token
  - Copy the generated token
- **Example**: `squ_1234567890abcdef1234567890abcdef12345678`

### 2. Kubernetes Cluster Access
```
KUBE_CONFIG
```
- **Description**: Base64 encoded kubeconfig file for cluster access
- **How to get**:
  ```bash
  # Get your kubeconfig content
  cat ~/.kube/config | base64 -w 0
  ```
- **Example**: `YXBpVmVyc2lvbjogdjEKY2x1c3RlcnM6Ci0gY2x1c3RlcjoK...`

### 3. Email Notifications
```
EMAIL_USERNAME
EMAIL_PASSWORD  
EMAIL_TO
```
- **EMAIL_USERNAME**: Your Gmail address (e.g., `devops@company.com`)
- **EMAIL_PASSWORD**: Gmail App Password (NOT your regular password)
- **EMAIL_TO**: Recipient email address (e.g., `team@company.com`)

#### Gmail App Password Setup:
1. Enable 2-Factor Authentication on Gmail
2. Go to Google Account → Security → 2-Step Verification → App passwords
3. Generate password for "GitHub Actions"
4. Use this 16-character password as `EMAIL_PASSWORD`

## Auto-Provided Secrets

These are automatically available in GitHub Actions:

### GitHub Token
```
GITHUB_TOKEN
```
- **Description**: Automatically provided by GitHub for repository access
- **Usage**: Container registry authentication, API access
- **No setup required**

## Optional Secrets

### Docker Registry (if using external registry)
```
DOCKER_USERNAME
DOCKER_PASSWORD
```
- **Description**: Docker Hub or private registry credentials
- **Only needed if**: Not using GitHub Container Registry (ghcr.io)

### Nexus Repository (if using Nexus)
```
NEXUS_USERNAME
NEXUS_PASSWORD
```
- **Description**: Sonatype Nexus repository credentials
- **Usage**: Artifact storage and retrieval

## Secrets Summary

| Secret Name | Required | Purpose |
|-------------|----------|---------|
| `SONAR_TOKEN` | ✅ Yes | Code quality analysis |
| `KUBE_CONFIG` | ✅ Yes | Kubernetes deployment |
| `EMAIL_USERNAME` | ✅ Yes | Email notifications |
| `EMAIL_PASSWORD` | ✅ Yes | Email authentication |
| `EMAIL_TO` | ✅ Yes | Notification recipient |
| `GITHUB_TOKEN` | 🔄 Auto | Container registry |
| `DOCKER_USERNAME` | ❌ Optional | External registry |
| `DOCKER_PASSWORD` | ❌ Optional | External registry |
| `NEXUS_USERNAME` | ❌ Optional | Artifact repository |
| `NEXUS_PASSWORD` | ❌ Optional | Artifact repository |

## Security Best Practices

1. **Never commit secrets** to the repository
2. **Use App Passwords** instead of regular passwords
3. **Rotate secrets regularly** (every 90 days)
4. **Limit secret scope** to minimum required permissions
5. **Monitor secret usage** in GitHub Actions logs
6. **Use environment-specific secrets** for different deployment targets

## Troubleshooting

### Common Issues:
- **SonarQube fails**: Check token validity and project permissions
- **Kubernetes deployment fails**: Verify kubeconfig and cluster connectivity
- **Email not sent**: Confirm Gmail App Password and 2FA enabled
- **Docker push fails**: Check GitHub Packages permissions

### Testing Secrets:
```bash
# Test kubectl access
echo $KUBE_CONFIG | base64 -d > /tmp/kubeconfig
kubectl --kubeconfig=/tmp/kubeconfig get nodes

# Test SonarQube token
curl -u $SONAR_TOKEN: https://your-sonarqube-url/api/authentication/validate
```