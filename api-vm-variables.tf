########################
## API VM - Variables ##
########################

# API VM Admin User
variable "api_admin_username" {
  type        = string
  description = "API VM Admin User"
  default     = "kopiadmin"
}

# API VM Admin Password
variable "api_admin_password" {
  type        = string
  description = "API VM Admin Password"
  default     = "S3cr3ts24"
}

# API Virtual Machine Name
variable "api_vm_name" {
  type        = string
  description = "API VM Size"
  default     = "kopiadapi01"
  validation {
    condition     = length(var.api_vm_name) < 16
    error_message = "VM Name must be a 15 character long name or less"
  }
}

# API Virtual Machine Size
variable "api_vm_size" {
  type        = string
  description = "API VM Size"
  default     = "Standard_B2s"
}

