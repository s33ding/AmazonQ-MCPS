#!/bin/bash
docker build -t mcp-server:latest .
docker tag mcp-server:latest <account-id>.dkr.ecr.us-east-1.amazonaws.com/mcp-server:latest
