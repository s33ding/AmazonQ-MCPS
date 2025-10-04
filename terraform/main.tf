terraform {
  required_version = ">= 1.0"
  
  backend "s3" {
    bucket = "s33ding-tf-mcp-backend"
    key    = "mcp-server/terraform.tfstate"
    region = "us-east-1"
  }
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# ECR Repository
resource "aws_ecr_repository" "mcp_server" {
  name                 = "mcp-server"
  image_tag_mutability = "MUTABLE"
  
  image_scanning_configuration {
    scan_on_push = true
  }
  
  tags = {
    Name = "mcp-server"
    Project = "amazon-q-mcp"
  }
}

# S3 bucket for MCP files sync
resource "aws_s3_bucket" "mcp_files" {
  bucket = "s33ding-mcp"
  
  tags = {
    Name = "mcp-files"
    Project = "amazon-q-mcp"
  }
}

# CodeBuild project
resource "aws_codebuild_project" "mcp_build" {
  name         = "mcp-server-build"
  service_role = aws_iam_role.codebuild_role.arn
  
  artifacts {
    type = "NO_ARTIFACTS"
  }
  
  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
    type         = "LINUX_CONTAINER"
    privileged_mode = true
    
    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = "us-east-1"
    }
    
    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = "248189947068"
    }
    
    environment_variable {
      name  = "IMAGE_REPO_NAME"
      value = aws_ecr_repository.mcp_server.name
    }
    
    environment_variable {
      name  = "MCP_FILES_BUCKET"
      value = aws_s3_bucket.mcp_files.bucket
    }
  }
  
  source {
    type = "S3"
    location = "${aws_s3_bucket.mcp_files.bucket}/source.zip"
    buildspec = "buildspec.yml"
  }
}

# IAM role for CodeBuild
resource "aws_iam_role" "codebuild_role" {
  name = "mcp-codebuild-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "codebuild_policy" {
  role = aws_iam_role.codebuild_role.id
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:GetAuthorizationToken",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:PutImage",
          "s3:GetObject",
          "s3:PutObject"
        ]
        Resource = "*"
      }
    ]
  })
}
