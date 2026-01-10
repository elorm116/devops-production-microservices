pipeline {
  agent any

  environment {
    AWS_REGION = "us-east-1"
    AWS_ACCOUNT_ID = credentials('aws-account-id')
    ECR_REGISTRY = "${AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com"
    IMAGE_TAG = "${env.GIT_COMMIT.take(7)}"
    EKS_CLUSTER_NAME = "devops-prod-eks"
  }

  stages {
    stage("Deploy to EKS") {
      steps {
        withCredentials([
          string(credentialsId: 'aws-access-key-id', variable: 'AWS_ACCESS_KEY_ID'),
          string(credentialsId: 'aws-secret-access-key', variable: 'AWS_SECRET_ACCESS_KEY')
        ]) {
          sh '''
            # Verify AWS credentials
            aws sts get-caller-identity
            
            # Update kubeconfig for EKS cluster
            aws eks update-kubeconfig \
              --region ${AWS_REGION} \
              --name ${EKS_CLUSTER_NAME}
            
            # Verify kubectl connectivity
            kubectl cluster-info
            
            # Update deployments with new images
            kubectl set image deployment/auth-service \
              auth-service=${ECR_REGISTRY}/auth-service:${IMAGE_TAG} \
              --record
            
            kubectl set image deployment/product-service \
              product-service=${ECR_REGISTRY}/product-service:${IMAGE_TAG} \
              --record
            
            kubectl set image deployment/order-service \
              order-service=${ECR_REGISTRY}/order-service:${IMAGE_TAG} \
              --record
            
            # Wait for rollouts to complete
            kubectl rollout status deployment/auth-service --timeout=5m
            kubectl rollout status deployment/product-service --timeout=5m
            kubectl rollout status deployment/order-service --timeout=5m
          '''
        }
      }
    }
  }
  
  post {
    success {
      echo "✅ Deployment successful!"
    }
    failure {
      echo "❌ Deployment failed!"
    }
  }
}