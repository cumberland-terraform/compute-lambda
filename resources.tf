resource "aws_lambda_function" "this" {
    function_name                   = var.lambda.function_name
    image_uri                       = var.lambda.image_url
    kms_key_arn                     = local.kms_key.arn
    memory_size                     = var.lambda.memory_size
    package_type                    = "Image"
    publish                         = true
    role                            = var.lambda.role
    timeout                         = var.lambda.timeout
    reserved_concurrent_executions  = var.lambda.reserved_concurrent_executions
    
    tracing_config {
        mode                        = local.lambda.tracing_config.mode
    }

    environment {
        variables                   = var.lambda.environment_variables
    }

    vpc_config {
        subnet_ids                  = module.platform.network.subnets.ids
        security_group_ids          = local.security_group_ids
    }
}

resource "aws_cloudwatch_log_group" "this" {
    kms_key_id                      = local.kms_key.arn
    name                            = "/aws/lambda/${var.lambda.function_name}"
    retention_in_days               = 14
}