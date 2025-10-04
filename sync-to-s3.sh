#!/bin/bash

BUCKET="s33ding-mcp"

echo "Syncing MCP files to S3 bucket: $BUCKET"

# Sync MCP files
aws s3 sync mcp/ s3://$BUCKET/mcp/

# Create source zip for CodeBuild
zip -r source.zip . -x "*.git*" "terraform/.terraform*"
aws s3 cp source.zip s3://$BUCKET/

echo "Files synced successfully!"
