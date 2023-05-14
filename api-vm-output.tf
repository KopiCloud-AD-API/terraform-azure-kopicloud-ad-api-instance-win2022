#####################
## API VM - Output ##
#####################

# API VM ID
output "api_vm_id" {
  value = azurerm_windows_virtual_machine.api-vm.id
}

# API VM Name
output "api_vm_name" {
  value = azurerm_windows_virtual_machine.api-vm.name
}

# API VM Admin Username
output "api_vm_admin_username" {
  value = var.api_admin_username
}

# API VM Admin Password
output "api_vm_admin_password" {
  value = var.api_admin_password
}

# API VM Public IP
output "api_vm_public_ip" {
  value = azurerm_public_ip.api-vm-ip.ip_address
}