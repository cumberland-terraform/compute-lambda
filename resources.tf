resource "aws_lambda_function" "this" {
    lifecycle {
      ignore_changes                = [ tags ]
    }
    
    function_name                   = local.function_name
    filename                        = local.filename
    image_uri                       = var.lambda.image_uri
    kms_key_arn                     = local.kms_key.arn
    memory_size                     = var.lambda.memory_size
    package_type                    = var.lambda.package_type
    publish                         = local.platform_defaults.publish
    source_code_hash                = local.source_code_hash
    role                            = local.role
    timeout                         = var.lambda.timeout
    runtime                         = local.runtime
    handler                         = local.handler
    reserved_concurrent_executions  = local.platform_defaults.reserved_concurrent_executions
    tags                            = local.tags
    
    tracing_config {
        mode                        = local.platform_defaults.tracing_config.mode
    }

    dynamic "environment" {
        for_each                        = try(var.lambda.environment.variables, null) == null ? (
                                          toset([]) 
                                        ) : toset([1])
        
        content {
            variables                 = environment.value["variables"]
        }
    }

    dynamic "vpc_config" {
        for_each                        = local.conditions.provision_sg ? (
                                          toset([1]) 
                                        ) : toset([0])
        
        content {
            subnet_ids                  = module.platform.network.subnets.ids
            security_group_ids          = local.security_group_ids
        }
    }
}

resource "aws_cloudwatch_log_group" "this" {
    count                           = var.lambda.logging ? 1 : 0
    
    lifecycle {
      ignore_changes                = [ tags ]
    }
    # TODO: need to find out which AWS managed key to use with Cloudwatch
    # kms_key_id                      = local.kms_key.arn
    
    name                            = "/aws/lambda/${local.function_name}"
    retention_in_days               = local.platform_defaults.retention_in_days
    tags                            = local.tags
}