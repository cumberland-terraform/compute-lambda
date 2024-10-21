variable "platform" {
  description             = "Platform metadata configuration object. See [Platform Module] (https://source.mdthink.maryland.gov/projects/etm/repos/mdt-eter-platform/browse) for detailed information about the permitted values for each field."
  type                    = object({
    aws_region            = string 
    account               = string
    acct_env              = string
    agency                = string
    app                   = string
    program               = string
    availability_zones    = list(string)
    pca                   = string
  })
}

variable "lambda" {
  description             = "todo"
  type                    = object({
    role                  = optional(string, "IMR-MDT-COST-LAMBDA")
    suffix                = optional(string, null)
    package_type          = optional(string, "Image")
    image_uri             = optional(string, null)
    source_file           = optional(string, null)
    memory_size           = optional(number, 512)
    timeout               = optional(number, 100)
    runtime               = optional(string, "python3.12")
    kms_key               = optional(object({
      aws_managed         = optional(bool, false)
      id                  = string
      arn                 = string
      alias_arn           = string 
    }), null)
    
    environment           = optional(object({
      variables           = map(any)
    }), null)

    vpc_config            = optional(object({
      security_group_ids  = optional(list(string), null)
    }), {
      security_group_ids  = []
    })
  })

  validation {
    condition             = var.lambda.package_type == "Image" && var.lambda.image_uri != null
    error_message         = "The Image URI must be specified if package type is Image"
  }

  validation {
    condition             = var.lambda.package_type == "Zip" && var.lambda.source_file != null
    error_message         = "The source file must be specified if package type is Zip"
  }
}