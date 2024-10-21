resource "aws_lambda_function" "this" {
    function_name                   = local.function_name
    filename                        = local.filename
    image_uri                       = var.lambda.image_uri
    kms_key_arn                     = local.kms_key.arn
    memory_size                     = var.lambda.memory_size
    package_type                    = var.lambda.package_type
    publish                         = local.platform_defaults.publish
    source_code_hash                = local.source_code_hash
    role                            = var.lambda.role
    timeout                         = var.lambda.timeout
    reserved_concurrent_executions  = local.platform_defaults.reserved_concurrent_executions
    
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
    name                            = "/aws/lambda/${local.function_name}"
    retention_in_days               = 14
}