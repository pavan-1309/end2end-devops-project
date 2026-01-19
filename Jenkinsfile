pipeline {
    agent any
    
    environment {
        DOCKER_REGISTRY = 'your-nexus-repo:8082'
        SONAR_HOST = 'http://sonarqube:9000'
        NEXUS_REPO = 'http://nexus:8081'
        DOCKER_TAG = "${BUILD_NUMBER}"
    }
    
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/your-repo/microservices-app.git'
            }
        }
        
        stage('Build Services') {
            parallel {
                stage('User Service') {
                    steps {
                        dir('microservices/user-service') {
                            sh 'mvn clean compile'
                        }
                    }
                }
                stage('Product Service') {
                    steps {
                        dir('microservices/product-service') {
                            sh 'mvn clean compile'
                        }
                    }
                }
                stage('API Gateway') {
                    steps {
                        dir('microservices/api-gateway') {
                            sh 'mvn clean compile'
                        }
                    }
                }
            }
        }
        
        stage('Unit Tests') {
            parallel {
                stage('User Service Tests') {
                    steps {
                        dir('microservices/user-service') {
                            sh 'mvn test'
                        }
                    }
                    post {
                        always {
                            publishTestResults testResultsPattern: 'microservices/user-service/target/surefire-reports/*.xml'
                        }
                    }
                }
                stage('Product Service Tests') {
                    steps {
                        dir('microservices/product-service') {
                            sh 'mvn test'
                        }
                    }
                    post {
                        always {
                            publishTestResults testResultsPattern: 'microservices/product-service/target/surefire-reports/*.xml'
                        }
                    }
                }
            }
        }
        
        stage('SonarQube Analysis') {
            parallel {
                stage('User Service Sonar') {
                    steps {
                        dir('microservices/user-service') {
                            withSonarQubeEnv('SonarQube') {
                                sh 'mvn sonar:sonar -Dsonar.projectKey=user-service'
                            }
                        }
                    }
                }
                stage('Product Service Sonar') {
                    steps {
                        dir('microservices/product-service') {
                            withSonarQubeEnv('SonarQube') {
                                sh 'mvn sonar:sonar -Dsonar.projectKey=product-service'
                            }
                        }
                    }
                }
            }
        }
        
        stage('OWASP Dependency Check') {
            parallel {
                stage('User Service OWASP') {
                    steps {
                        dir('microservices/user-service') {
                            sh 'mvn org.owasp:dependency-check-maven:check'
                        }
                    }
                    post {
                        always {
                            publishHTML([
                                allowMissing: false,
                                alwaysLinkToLastBuild: true,
                                keepAll: true,
                                reportDir: 'microservices/user-service/target',
                                reportFiles: 'dependency-check-report.html',
                                reportName: 'User Service OWASP Report'
                            ])
                        }
                    }
                }
                stage('Product Service OWASP') {
                    steps {
                        dir('microservices/product-service') {
                            sh 'mvn org.owasp:dependency-check-maven:check'
                        }
                    }
                    post {
                        always {
                            publishHTML([
                                allowMissing: false,
                                alwaysLinkToLastBuild: true,
                                keepAll: true,
                                reportDir: 'microservices/product-service/target',
                                reportFiles: 'dependency-check-report.html',
                                reportName: 'Product Service OWASP Report'
                            ])
                        }
                    }
                }
            }
        }
        
        stage('Package') {
            parallel {
                stage('User Service Package') {
                    steps {
                        dir('microservices/user-service') {
                            sh 'mvn package -DskipTests'
                        }
                    }
                }
                stage('Product Service Package') {
                    steps {
                        dir('microservices/product-service') {
                            sh 'mvn package -DskipTests'
                        }
                    }
                }
                stage('API Gateway Package') {
                    steps {
                        dir('microservices/api-gateway') {
                            sh 'mvn package -DskipTests'
                        }
                    }
                }
            }
        }
        
        stage('Docker Build') {
            parallel {
                stage('User Service Docker') {
                    steps {
                        script {
                            sh "cp microservices/user-service/target/user-service-1.0.0.jar microservices/user-service/"
                            sh "docker build -t ${DOCKER_REGISTRY}/user-service:${DOCKER_TAG} microservices/user-service/"
                        }
                    }
                }
                stage('Product Service Docker') {
                    steps {
                        script {
                            sh "cp microservices/product-service/target/product-service-1.0.0.jar microservices/product-service/"
                            sh "docker build -t ${DOCKER_REGISTRY}/product-service:${DOCKER_TAG} microservices/product-service/"
                        }
                    }
                }
                stage('API Gateway Docker') {
                    steps {
                        script {
                            sh "cp microservices/api-gateway/target/api-gateway-1.0.0.jar microservices/api-gateway/"
                            sh "docker build -t ${DOCKER_REGISTRY}/api-gateway:${DOCKER_TAG} microservices/api-gateway/"
                        }
                    }
                }
                stage('Frontend Docker') {
                    steps {
                        script {
                            sh "docker build -t ${DOCKER_REGISTRY}/frontend:${DOCKER_TAG} microservices/frontend/"
                        }
                    }
                }
            }
        }
        
        stage('Trivy Security Scan') {
            parallel {
                stage('User Service Trivy') {
                    steps {
                        sh "trivy image --format json --output user-service-scan.json ${DOCKER_REGISTRY}/user-service:${DOCKER_TAG}"
                    }
                }
                stage('Product Service Trivy') {
                    steps {
                        sh "trivy image --format json --output product-service-scan.json ${DOCKER_REGISTRY}/product-service:${DOCKER_TAG}"
                    }
                }
                stage('API Gateway Trivy') {
                    steps {
                        sh "trivy image --format json --output api-gateway-scan.json ${DOCKER_REGISTRY}/api-gateway:${DOCKER_TAG}"
                    }
                }
                stage('Frontend Trivy') {
                    steps {
                        sh "trivy image --format json --output frontend-scan.json ${DOCKER_REGISTRY}/frontend:${DOCKER_TAG}"
                    }
                }
            }
        }
        
        stage('Push to Nexus') {
            steps {
                script {
                    withDockerRegistry([credentialsId: 'nexus-docker', url: "http://${DOCKER_REGISTRY}"]) {
                        sh "docker push ${DOCKER_REGISTRY}/user-service:${DOCKER_TAG}"
                        sh "docker push ${DOCKER_REGISTRY}/product-service:${DOCKER_TAG}"
                        sh "docker push ${DOCKER_REGISTRY}/api-gateway:${DOCKER_TAG}"
                        sh "docker push ${DOCKER_REGISTRY}/frontend:${DOCKER_TAG}"
                    }
                }
            }
        }
        
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    sh "sed -i 's|IMAGE_TAG|${DOCKER_TAG}|g' k8s/*.yaml"
                    sh "kubectl apply -f k8s/"
                    sh "kubectl rollout status deployment/user-service"
                    sh "kubectl rollout status deployment/product-service"
                    sh "kubectl rollout status deployment/api-gateway"
                    sh "kubectl rollout status deployment/frontend"
                }
            }
        }
        
        stage('Integration Tests') {
            steps {
                script {
                    sh 'chmod +x ci-cd/integration-tests.sh'
                    sh './ci-cd/integration-tests.sh'
                }
            }
        }
    }
    
    post {
        always {
            archiveArtifacts artifacts: '**/*-scan.json', allowEmptyArchive: true
            cleanWs()
        }
        success {
            slackSend channel: '#devops', 
                     color: 'good', 
                     message: "✅ Pipeline succeeded for build ${BUILD_NUMBER}"
        }
        failure {
            slackSend channel: '#devops', 
                     color: 'danger', 
                     message: "❌ Pipeline failed for build ${BUILD_NUMBER}"
        }
    }
}