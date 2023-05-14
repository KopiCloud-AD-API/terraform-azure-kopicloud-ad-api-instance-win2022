###################
## API VM - Main ##
###################

# Create Network Security Group to Access the API VM from Internet
resource "azurerm_network_security_group" "api-vm-nsg" {
  name                = "${var.app_name}-${var.environment}-vm-nsg"
  location            = azurerm_resource_group.network-rg.location
  resource_group_name = azurerm_resource_group.network-rg.name

  security_rule {
    name                       = "allow-rdp"
    description                = "allow-rdp"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*" 
  }

  security_rule {
    name                       = "allow-https"
    description                = "allow-https"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

  tags = {
    application = var.app_name
    environment = var.environment 
  }
}

# Associate the NSG with the Subnet
resource "azurerm_subnet_network_security_group_association" "api-vm-nsg-association" {
  depends_on=[azurerm_network_security_group.api-vm-nsg]

  subnet_id                 = azurerm_subnet.network-subnet.id
  network_security_group_id = azurerm_network_security_group.api-vm-nsg.id
}

# Get a Static Public IP for the API VM
resource "azurerm_public_ip" "api-vm-ip" {
  name                = "${var.app_name}-${var.environment}-vm-pip"
  location            = azurerm_resource_group.network-rg.location
  resource_group_name = azurerm_resource_group.network-rg.name
  allocation_method   = "Static"
  
  tags = { 
    application = var.app_name
    environment = var.environment 
  }
}

# Create Network Card for the API VM
resource "azurerm_network_interface" "api-vm-nic" {
  depends_on=[azurerm_public_ip.api-vm-ip]

  name                = "${var.app_name}-${var.environment}-vm-nic"
  location            = azurerm_resource_group.network-rg.location
  resource_group_name = azurerm_resource_group.network-rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.network-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.api-vm-ip.id
  }

  tags = { 
    application = var.app_name
    environment = var.environment 
  }
}

# Create API Server
resource "azurerm_windows_virtual_machine" "api-vm" {
  depends_on=[azurerm_network_interface.api-vm-nic]

  name                  = "${var.app_name}-${var.environment}-vm"
  location              = azurerm_resource_group.network-rg.location
  resource_group_name   = azurerm_resource_group.network-rg.name
  size                  = var.api_vm_size
  network_interface_ids = [azurerm_network_interface.api-vm-nic.id]
  
  computer_name  = var.api_vm_name
  admin_username = var.api_admin_username
  admin_password = var.api_admin_password

  os_disk {
    name                 = "${var.app_name}-${var.environment}-vm-os-disk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }

  enable_automatic_updates = true
  provision_vm_agent       = true

  tags = {
    application = var.app_name
    environment = var.environment 
  }
}

# Add Azure VM extension
resource "azurerm_virtual_machine_extension" "api-extension" {
  name                 = "${var.app_name}-${var.environment}-vm-extension"
  virtual_machine_id   = azurerm_windows_virtual_machine.api-vm.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  settings = <<SETTINGS
      {
          "fileUris": ["https://raw.githubusercontent.com/KopiCloud-AD-API/kopicloud-ad-api-setup-scripts/main/setup-win2022.ps1"],
          "commandToExecute": "powershell -ExecutionPolicy Unrestricted -File setup-win2022.ps1"
      }
  SETTINGS
}