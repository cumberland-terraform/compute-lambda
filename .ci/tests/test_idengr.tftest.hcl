provider "aws" {
    region                                  = "us-east-1"
    assume_role {
        role_arn                            = "arn:aws:iam::798223307841:role/IMR-MDT-TERA-EC2"
    }
}

mock_provider "aws" {
    alias                                   = "fake"
}

variables {
    platform                                = {
        aws_region                          = "US EAST 1"
        account                             = "ID ENGINEERING"
        acct_env                            = "NON-PRODUCTION 1"
        agency                              = "MARYLAND TOTAL HUMAN-SERVICES INTEGRATED NETWORK"
        program                             = "MDTHINK SHARED PLATFORM"
        app                                 = "KUBERNETES WORKER NODE"
        app_env                             = "NON PRODUCTION"
        domain                              = "ENGINEERING"
        pca                                 = "FE110"
        owner                               = "AWS DevOps Team"
        availability_zones                  = [ "A01", "C01" ]
    }
    
    lambda                                  = {
        role                                = "TEST_DATA"
    }
}
