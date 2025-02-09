terraform {
    required_providers{
        aws = {
            source = "hashicorp/aws"
            version = "5.86.0"
        }

        azure = {
            source = "hashicorp/azurerm"
            version = "4.18.0"
        }
    }
}

