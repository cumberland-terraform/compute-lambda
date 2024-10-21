data "aws_kms_key" "this" {
    count                   = var.lambda.kms_key.aws_managed ? 1 : 0

    key_id                  = local.lambda_defaults.aws_managed_key_alias
}