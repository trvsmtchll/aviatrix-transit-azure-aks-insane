# Aviatrix Transit Azure (insane mode HPE) with AKS and Ubuntu Test VM

### Summary

This repo builds Aviatrix Transit in Azure **insane mode HPE**, spokes attached each with an ubuntu test vm. 
The test VM will use password authentication (randomly generated), have port 22 open and be provided public IPs. The test vm object(s) will be generated per spoke review output for public ip's.

### BOM

- 1 Aviatrix Transit in Azure with an 2 Aviatrix spokes defined in terraform.tfvars, i.e. ```azure_spokes = { "test1" = "10.23.0.0/20", "test2" = "10.24.0.0/20" }``` attached to Aviatrix Transit Gateway.
- 1 Azure Resource Group with Ubuntu 18.04 VM per spoke (iperf3 installed)
- 1 AKS Spoke
- 1 Azure Kubernetes Service with nginx helm chart

### Infrastructure diagram

<img src="img/azure-aks-kit.png" height="400">

### Azure Kubernetes 

Note the Cluster IP and External IPs for the nginx service.

<img src="img/azure-aks-svcs.png" height="400">

### Azure Resource Group

<img src="img/azure-rg.png" height="400">


### Compatibility
Terraform version | Controller version | Terraform provider version
:--- | :--- | :---
0.13 | 6.3 | 2.18.1

### Modules

Module Name | Version | Description
:--- | :--- | :---
[terraform-aviatrix-modules/azure-transit/aviatrix](https://registry.terraform.io/modules/terraform-aviatrix-modules/azure-transit/aviatrix/latest) | 3.0.0 | This module deploys a VNET, Aviatrix transit gateways.
[terraform-aviatrix-modules/azure-spoke/aviatrix](https://registry.terraform.io/modules/terraform-aviatrix-modules/azure-spoke/aviatrix/latest) | 3.0.0 | This module deploys a VNET and an Aviatrix spoke gateway in Azure and attaches it to an Aviatrix Transit Gateway
[Azure/compute/azurerm](https://registry.terraform.io/modules/Azure/compute/azurerm/0.9.0) | 0.9.0 | Azure Terraform module to deploy virtual machines

### Helm Charts
Chart | Version | Description
:--- | :--- | :---
[bitnami/nginx](https://artifacthub.io/packages/helm/bitnami/nginx) | 8.7.1 |  NGINX (pronounced "engine-x") is an open source reverse proxy server for HTTP, HTTPS, SMTP, POP3, and IMAP protocols, as well as a load balancer, HTTP cache, and a web server (origin server).

### Variables

The variables are defined in ```terraform.tfvars```.

**Note:** ```ha_enabled = false``` controls whether ha is built for spokes. 

```instance_size``` controls the size of all the transit spokes and gateways. 

```test_instance_size``` controls the size of the test vms.

### Prerequisites

- Software version requirements met
- Aviatrix Controller with Access Account in Azure
- Sufficient limits in place for Azure region in scope **_(Compute quotas, etc.)_**
- terraform .13 in the user environment ```terraform -v``` **_or use hashicorp/terraform docker image_** Instructions below.
- [Install the the azure cli](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-macos) on the workstation and authenticate with ```az login```

### Workflow

- Modify ```terraform.tfvars``` _(i.e. access account name, regions, cidrs, etc.)_ and save the file.
- ```terraform init```
- ```terraform plan```
- ```terraform apply --auto-approve```

### Test command examples

You can ssh into the the test vm's created in azure like so...

```ssh azureuser/test_vm_password@public_ip_address```

**test_vm_password,public_ip_address** will be in terraform output

#### iperf

Replace with the private IP of one of the created test vms - check terraform output for the value.
Run the client on one test vm and the server on another test vm.

```
iperf3 -s -p 5201 # on Spoke 1
iperf3 -c 10.24.1.4 -i 2 -t 30 -M 1400 -P 10 -p 5201 # on Spoke 2
```

[iperf3 detail]((./azure-insane-iperf3.md))

### kubernetes  

Depending on your requirements testing will nginx provides a basic mechanism to curl and get a result back. 

### Deploy with hashicorp docker image _optional_

#### 1) Pull the 13.6 image
```
docker pull hashicorp/terraform:0.13.6
```
#### 2) Init in $PWD with environment variables set
```
docker run -i -t -v $PWD:$PWD -w $PWD \
--env TF_VAR_username=$TF_VAR_username \
--env TF_VAR_password=$TF_VAR_password \
--env TF_VAR_controller_ip=$TF_VAR_controller_ip \
hashicorp/terraform:0.13.6 init
```

#### 3) Plan in $PWD with environment variables set
```
docker run -i -t -v $PWD:$PWD -w $PWD \
--env TF_VAR_username=$TF_VAR_username \
--env TF_VAR_password=$TF_VAR_password \
--env TF_VAR_controller_ip=$TF_VAR_controller_ip \
hashicorp/terraform:0.13.6 plan
```

#### 4) Apply in $PWD with environment variables set
```
docker run -i -t -v $PWD:$PWD -w $PWD \
--env TF_VAR_username=$TF_VAR_username \
--env TF_VAR_password=$TF_VAR_password \
--env TF_VAR_controller_ip=$TF_VAR_controller_ip \
hashicorp/terraform:0.13.6 apply --auto-approve
```


### Terraform state (post-provisioning)

```
$ terrafform state list
data.azurerm_subscription.current
data.azurerm_subscription.primary
data.template_file.azure-init
azurerm_kubernetes_cluster.aks
azurerm_resource_group.example
azurerm_role_assignment.aks
azurerm_subnet.vng_gateway_subnet
helm_release.nginx
local_file.local-config-file
random_password.password
module.azure_aks_spoke.aviatrix_spoke_gateway.default
module.azure_aks_spoke.aviatrix_spoke_transit_attachment.default[0]
module.azure_aks_spoke.aviatrix_vpc.default
module.azure_spoke["test1"].aviatrix_spoke_gateway.default
module.azure_spoke["test1"].aviatrix_spoke_transit_attachment.default[0]
module.azure_spoke["test1"].aviatrix_vpc.default
module.azure_spoke["test2"].aviatrix_spoke_gateway.default
module.azure_spoke["test2"].aviatrix_spoke_transit_attachment.default[0]
module.azure_spoke["test2"].aviatrix_vpc.default
module.azure_test_vm["test1"].data.azurerm_public_ip.vm[0]
module.azure_test_vm["test1"].data.azurerm_resource_group.vm
module.azure_test_vm["test1"].azurerm_availability_set.vm
module.azure_test_vm["test1"].azurerm_network_interface.vm[0]
module.azure_test_vm["test1"].azurerm_network_interface_security_group_association.test[0]
module.azure_test_vm["test1"].azurerm_network_security_group.vm
module.azure_test_vm["test1"].azurerm_network_security_rule.vm[0]
module.azure_test_vm["test1"].azurerm_public_ip.vm[0]
module.azure_test_vm["test1"].azurerm_virtual_machine.vm-linux[0]
module.azure_test_vm["test1"].random_id.vm-sa
module.azure_test_vm["test2"].data.azurerm_public_ip.vm[0]
module.azure_test_vm["test2"].data.azurerm_resource_group.vm
module.azure_test_vm["test2"].azurerm_availability_set.vm
module.azure_test_vm["test2"].azurerm_network_interface.vm[0]
module.azure_test_vm["test2"].azurerm_network_interface_security_group_association.test[0]
module.azure_test_vm["test2"].azurerm_network_security_group.vm
module.azure_test_vm["test2"].azurerm_network_security_rule.vm[0]
module.azure_test_vm["test2"].azurerm_public_ip.vm[0]
module.azure_test_vm["test2"].azurerm_virtual_machine.vm-linux[0]
module.azure_test_vm["test2"].random_id.vm-sa
module.azure_transit_1.aviatrix_transit_gateway.default
module.azure_transit_1.aviatrix_vpc.default

```
