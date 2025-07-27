module "platform" {
  source                = "github.com/cumberland-terraform/platform"

  platform              = local.platform
}

module "kms" {
  count                 = local.conditions.provision_key ? 1 : 0
  source                = "github.com/cumberland-terraform/security-kms"

  kms                   = local.kms
  platform              = local.platform
}

module "sg"        {
  count                 = local.conditions.provision_sg ? 1 : 0
  source                = "github.com/cumberland-terraform/security-sg"

  sg                    = local.security_group
  platform              = local.platform
}
