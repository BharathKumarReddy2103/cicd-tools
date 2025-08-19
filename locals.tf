locals{
    ami_id = data.aws_ami.bharathdevops.id
    common_tags = {
        Project = var.project
        Environment = var.environment
        Terraform = "true"
    }
}