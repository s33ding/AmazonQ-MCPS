#!/bin/bash

# Get AWS account ID
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
REGION="us-east-1"
REPO_NAME="mcp-server"

echo "Deploying MCP Server to EKS..."

# Create ECR repository
aws ecr create-repository --repository-name $REPO_NAME --region $REGION || true

# Get ECR login
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com

# Build and push image
cd docker-img
docker build -t $REPO_NAME:latest .
docker tag $REPO_NAME:latest $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$REPO_NAME:latest
docker push $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$REPO_NAME:latest

# Update deployment files with account ID
cd ../eks-deployment
sed -i "s/<account-id>/$ACCOUNT_ID/g" deployment.yaml

# Deploy to EKS
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml

echo "Deployment complete!"
kubectl get pods -l app=mcp-server
