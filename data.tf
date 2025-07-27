data "aws_kms_key" "this" {
    count                   = var.kms.aws_managed ? 1 : 0

    key_id                  = local.platform_defaults.aws_managed_key_alias
}

data "archive_file" "this" {
    count                   = local.conditions.is_zip ? 1 : 0

    type                    = "zip"
    source_file             = var.lambda.source_file
    output_path             = local.filename
}