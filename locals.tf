locals {
    ## CONDITIONS
    #   Configuration object containing boolean calculations that correspond
    #       to different deployment configurations.
    conditions                          = {
        provision_key                   = var.lambda.kms_key == null
        provision_sg                    = length(var.lambda.vpc_config.security_group_ids) == 0
        is_image                        = var.lambda.package_type == "Image"
        is_zip                          = var.lambda.package_Type == "Zip"
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
    }
    
    ## CALCULATED PROPERTIES
    #   Properties that change based on deployment configurations
    filename                            = local.conditions.is_zip ? "${path.module}/src/payload.zip" : null
    source_code_hash                    = local.conditions.is_zip ? (
                                            data.archive_file.this[0].output_base64sha256 
                                        ): null

    function_name                       = join("-", concat([
                                            module.platform.prefixes.lambda.function,
                                        ], var.lambda.suffix != null ? [
                                            var.lambda.suffix
                                        ] : []))

    kms_key                             = local.conditions.provision_key ? (
                                            module.kms[0].key
                                        ) : !var.lambda.kms_key.aws_managed ? (
                                            var.lambda.kms_key
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

    security_group_ids                  = local.conditions.provision_sg ? [
                                            module.sg[0].security_group.id
                                        ] :  var.lambda.vpc_config.security_group_ids
    
    platform                            = merge({
        subnet_type                     = "NETWORK ADDRESS TRANSLATION"
    }, var.platform)

    tags                                = merge({
       Name                             = local.function_name
    }, module.platform.tags)


}