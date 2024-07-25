locals {
    ## CONDITIONS
    #   Configuration object containing boolean calculations that correspond
    #       to different deployment configurations.
    conditions                      = {
        provision_kms_key           = var.lambda.kms_key == null
    }

    ## <SERVICE> DEFAULTS
    #   These are platform defaults and should only be changed when the 
    #       platform itself changes.
    platform_defaults                   = {
        # TODO: platform defaults go here
    }
    
    lambda                              = {
        tracing_config                  = {
            mode                        = "PassThrough"
        }
        timeout                         = 100
        reserved_concurrent_executions  = 50
    }
    ## CALCULATED PROPERTIES
    # Variables that store local calculations
    tags                                = merge({
        # TODO: service specific tags go here
    }, module.platform.tags)


}