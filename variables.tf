variable "platform" {
  description             = "Platform metadata configuration object. See [Platform Module] (https://source.mdthink.maryland.gov/projects/etm/repos/mdt-eter-platform/browse) for detailed information about the permitted values for each field."
  type                    = object({
    aws_region            = string 
    account               = string
    acct_env              = string
    agency                = string
    program               = string
    app                   = string
    app_env               = string
    availability_zones    = list(string)
    subnet_type           = string
    pca                   = string
  })
}

variable "lambda" {
  description             = "todo"
  type                    = object({
    role                  = string

    environment           = optional(object({
      variables           = map(any)
    }))

    vpc_config            = optional(object({
      security_group_ids  = optional(list(string), null)
    }), {
      security_group_ids  = []
    })

    memory_size           = optional(number, 512)
    timeout               = optional(number, 100)
    
    kms_key               = optional(object({
      aws_managed         = optional(bool, false)
      id                  = string
      arn                 = string
      alias_arn           = string 
    }), null)
  })
}