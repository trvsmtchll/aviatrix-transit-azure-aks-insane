// Modify values below as needed
# Aviatrix Controller
#controller_ip = "REPLACE_ME"
#username      = "REPLACE_ME"
#password      = "REPLACE_ME"

# Azure Access Account Name defined in Controller
azure_account_name = "TM-Azure" # Replace this with your Access Account name

# Aviatrix Gateway size
instance_size = "Standard_D3_v2"
# Test VM Kit
test_instance_size = "Standard_DS3_v2"

# HA flags
ha_enabled = false

# Transit Gateway Network Variables
// Transit
azure_transit_cidr1   = "10.21.2.0/20"
azure_region1         = "East US"
azure_vng_subnet_cidr = "10.21.6.0/27"

// Spokes
azure_vm_spokes = { "test" = "10.23.1.0/20" } 

azure_aks_spoke_cidr = "10.22.1.0/20"