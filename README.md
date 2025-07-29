# Enterprise Terraform 
## Cumberland Cloud Platform
## AWS Compute - Lambda

This module provisions a Lambda function on AWS.

### Usage

The bare minimum deployment can be achieved with the following configuration,

**providers.tf**

```hcl
provider "aws" {
	alias 					= "tenant"
	region					= "us-east-1"

	assume_role {
		role_arn 			= "arn:aws:iam::<tenant-account>:role/<role-name>"
	}
}
```

**modules.tf**

```
module "lambda" {
	source          		= "github.com/cumberland-cloud/compute-lambda"
	
	platform	           	= {
		client 				= "<client>
		environment 		= "<environment>
	}

	lambda			        = {
        image_uri			= "<image-uri>
	}
}
```

`platform` is a parameter for *all* **Cumberland Cloud Terraform** modules. For more information about the `platform`, in particular the permitted values of the nested fields, see the platform module documentation. The following section goes into more detail regarding the `lambda` variable.

### Parameters

TODO

**Note**: The Lambda is configured to use a ``PackageType = Image`` by default. 