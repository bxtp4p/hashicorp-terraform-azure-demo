# Terraform Demo

Demonstrating a Terraform Configuration for provisioning Azure resources.

## Demos

The `Getting Started` demo is a simple example and uses Azure CLI authentication. The `Multi-Tier Demo` uses a Service Principal for authentication. The Service Principal info can be set in the `terraform.tfstate` file.


## Known Issues

1. Running `terraform destroy` fails when Terraform attempts to destroy the `azurerm_mysql_database.db` resource. To work around this, remove it from the Terraform state `terraform state rm azurerm_mysql_database.db` and then run `terraform destroy` again.