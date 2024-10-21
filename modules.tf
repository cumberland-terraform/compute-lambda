module "platform" {
  source                = "git::ssh://git@source.mdthink.maryland.gov:22/etm/mdt-eter-platform.git?ref=v1.0.19&depth=1"

  platform              = local.platform
  hydration             = {
    vpc_query           = true
    subnets_query       = true
    dmem_sg_query       = false
    rhel_sg_query       = false
    eks_ami_query       = false
    acm_cert_query      = false
  }
}

module "kms" {
  count                 = local.conditions.provision_key ? 1 : 0
  source                = "git::ssh://git@source.mdthink.maryland.gov:22/etm/mdt-eter-core-security-kms.git?ref=v1.0.2&depth=1"

  kms                   = {
      alias_suffix      = local.suffix
  }
  platform              = local.platform
}

module "sg"        {
  count                 = local.conditions.provision_sg ? 1 : 0
  source                = "git::ssh://git@source.mdthink.maryland.gov:22/etm/mdt-eter-core-security-sg.git?depth=1"

  sg                    = local.security_group
  platform              = local.platform
}
