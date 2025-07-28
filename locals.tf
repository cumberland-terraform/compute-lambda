locals {
    ## CONDITIONS
    #   Configuration object containing boolean calculations that correspond
    #       to different deployment configurations.
    conditions                          = {
        provision_key                   = var.kms == null
        provision_sg                    = length(var.lambda.vpc_config.security_group_ids) == 0
        is_image                        = var.lambda.package_type == "Image"
        is_zip                          = var.lambda.package_type == "Zip"
    }

    ## LAMBDA DEFAULTS
    #   These are platform defaults and should only be changed when the 
    #       platform itself changes.
    platform_defaults                   = {
        tracing_config                  = {
            mode                        = "PassThrough"
        }
        reserved_concurrent_executions  = 50
        publish                         = true
        aws_managed_key_alias           = "alias/aws/lambda"
        retention_in_days               = 14
    }
    
    ## CALCULATED PROPERTIES
    #   Properties that change based on deployment configurations
    filename                            = local.conditions.is_zip ? "${path.module}/src/payload.zip" : null

    source_code_hash                    = local.conditions.is_zip ? (
                                            data.archive_file.this[0].output_base64sha256 
                                        ) : null

    function_name                       = join("-", concat([
                                            module.platform.prefixes.compute.lambda.function,
                                        ], var.lambda.suffix != null ? [
                                            var.lambda.suffix
                                        ] : []))

    kms                                 = {
        alias_suffix                    = local.suffix
    }

    kms_key                             = local.conditions.provision_key ? (
                                            module.kms[0].key
                                        ) : !var.kms.aws_managed ? (
                                            var.kms
                                        ) :  merge({
                                            # NOTE: the different objects on either side of the ? ternary operator
                                            #       have to match type, so hacking the types together.
                                            aws_managed = true
                                            alias_arn   = join("/", [
                                                module.platform.aws.arn.kms.key,
                                                local.platform_defaults.aws_managed_key_alias
                                            ])
                                        }, {
                                            id          = data.aws_kms_key.this[0].id
                                            arn         = data.aws_kms_key.this[0].arn
                                        })

    suffix                              = var.lambda.suffix == null ? "LAMBDA" : join("-", [
                                            "LAMBDA",
                                            var.lambda.suffix
                                        ])

    security_group                      = {
        suffix                          = local.suffix
        description                     = "Security Group for Lambda"
        inbound_rules                   = [{
            description                 = "HTTP Ingress from self"
            from_port                   = 0
            to_port                     = 65535
            protocol                    = "-1"
            self                        = true
        }]
    }

    security_group_ids                  = local.conditions.provision_sg ? [
                                            module.sg[0].security_group.id
                                        ] :  var.lambda.vpc_config.security_group_ids
    
    runtime                             = local.conditions.is_zip ? var.lambda.runtime : null
    handler                             = local.conditions.is_zip ? var.lambda.handler : null
    role                                = var.lambda.role == null ? (
                                            # TODO: if this is the platform lambda role, it should be pulled
                                            #       from the platform module!
                                            "${module.platform.aws.arn.iam.role}/IMR-MDT-COST-LAMBDA"
                                        ) : var.lambda.role

    platform                            = merge({
        subnet_type                     = "PRIVATE"
    }, var.platform)

    tags                                = merge({
       Name                             = local.function_name
    }, module.platform.tags)


}