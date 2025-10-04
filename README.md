# AmazonQ-MCPS
This repository provides a comprehensive Model Context Protocol (MCP) server implementation for Amazon Q, featuring multiple deployment options from local development to production-ready cloud infrastructure.

## MCP Architecture

Model Context Protocol (MCP) enables AI assistants to connect with external tools and data sources through standardized communication.

### Architecture Overview

```
┌─────────────────┐    MCP Protocol    ┌─────────────────┐    Cloud Infrastructure
│                 │ ◄─────────────────► │                 │    ┌─────────────────┐
│   Amazon Q      │                    │   MCP Server    │ ◄──┤ EKS/ECR/S3      │
│   CLI Client    │                    │   (Python)      │    │ Terraform       │
│                 │                    │                 │    │ CI/CD Pipeline  │
└─────────────────┘                    └─────────────────┘    └─────────────────┘
```

### Components

- **Amazon Q CLI**: MCP-compatible AI assistant client
- **MCP Server**: Python server providing custom tools via JSON-RPC over stdin/stdout
- **Cloud Infrastructure**: Containerized deployment on AWS EKS with ECR and S3
- **CI/CD Pipeline**: Automated build and deployment using AWS CodeBuild

## Quick Start

### Local Development

1. Install dependencies:
   ```bash
   cd mcp && pip install -r requirements.txt
   ```

2. Configure MCP server for Amazon Q:
   ```bash
   python mcp/setup_mcp.py
   ```

3. Start Amazon Q CLI:
   ```bash
   q chat
   ```

4. Test the MCP server:
   - Ask: "What tools are available?"
   - Try: "Use the greet tool with Roberto"

### Manual Setup

Run the MCP server directly:
```bash
python mcp/simple_mcp_server.py
```

Configure Amazon Q by creating `~/.aws/amazonq/mcpAdmin/servers.json`

## Deployment Options

### Docker Deployment

Build and run containerized MCP server:
```bash
cd docker-img
./build.sh
```

### EKS Deployment

Deploy to Amazon EKS cluster:
```bash
./deploy.sh
```

This script:
- Creates ECR repository
- Builds and pushes Docker image
- Deploys to EKS using Kubernetes manifests

### Terraform Infrastructure

Provision AWS resources:
```bash
cd terraform
terraform init
terraform plan
terraform apply
```

Creates:
- ECR repository for container images
- S3 bucket for MCP files synchronization
- IAM roles and policies

### S3 Sync Pipeline

The `buildspec.yml` defines an AWS CodeBuild pipeline that syncs MCP files to S3 for distribution and backup.

## Project Structure

```
├── mcp/                    # MCP server implementation
│   ├── simple_mcp_server.py
│   ├── setup_mcp.py
│   └── requirements.txt
├── docker-img/             # Docker configuration
├── eks-deployment/         # Kubernetes manifests
├── terraform/              # Infrastructure as code
├── buildspec.yml          # CI/CD pipeline
└── deploy.sh              # Deployment automation
```
