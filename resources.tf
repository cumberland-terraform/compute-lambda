resource "aws_lambda_function" "this" {
    #checkov:skip=CKV_AWS_272: "Ensure AWS Lambda function is configured to validate code-signing"
        # TODO: sign ECR images

    function_name                   = var.lambda.function_name
    image_uri                       = var.lambda.image_url
    kms_key_arn                     = local.encryption_configuration.arn
    memory_size                     = var.lambda.memory
    package_type                    = "Image"
    publish                         = true
    role                            = var.lambda.execution_role.arn
    timeout                         = var.lambda.timeout
    reserved_concurrent_executions  = var.lambda.reserved_concurrent_executions
    
    dead_letter_config {
        target_arn                  = aws_sns_topic.this.arn
    }

    tracing_config {
        mode                        = local.lambda.tracing_config.mode
    }

    environment {
        variables               = var.lambda.environment_variables
    }

    vpc_config {
        subnet_ids              = var.lambda.vpc_config.subnet_ids
        security_group_ids      = var.lambda.vpc_config.security_group_ids
    }
}

resource "aws_cloudwatch_log_group" "this" {
    #checkov:skip=CKV_AWS_338: "Ensure CloudWatch log groups retains logs for at least 1 year"
        # NOTE: checkov's a golddigger
    kms_key_id                      = local.encryption_configuration.arn
    name                            = "/aws/lambda/${var.lambda.function_name}"
    retention_in_days               = 14
}