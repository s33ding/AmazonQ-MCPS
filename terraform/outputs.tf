output "ecr_repository_url" {
  value = aws_ecr_repository.mcp_server.repository_url
}

output "mcp_files_bucket" {
  value = aws_s3_bucket.mcp_files.bucket
}

output "codebuild_project_name" {
  value = aws_codebuild_project.mcp_build.name
}
