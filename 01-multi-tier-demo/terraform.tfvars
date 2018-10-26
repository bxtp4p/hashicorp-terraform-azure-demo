# Azure Provider Variable Values
az_subscription_id  = ""
az_tenant_id        = ""
az_client_id        = ""
az_client_secret    = ""

# Resource Group Variable Values
rg_prefix           = "tfdemo"

# VM Variable Values
vm_admin_username               = "tfadmin"
vm_count                        = 2
vm_ssh_public_key               = "~/.ssh/id_rsa.pub"
vm_ssh_private_key              = "~/.ssh/id_rsa"

# Load Balancer Variable Values
lb_pip_dns_name = "tfdemo"

# DB Variable Values
db_mysql_admin_login      = "TFDBAdmin"
db_mysql_admin_password   = "T3rr4f0rm" # Should be in Vault
db_name                   = "petclinic"
db_ip_allowed_start       = "107.213.15.1"
db_ip_allowed_end         = "107.213.15.255"
db_init_db_script         = "../99-app-assets/db/config.sh"

# Network Security Group Variable Values
nsg_ssh_address_prefix = "107.213.15.0/24"