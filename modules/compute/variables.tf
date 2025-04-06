variable "compartment_ocid" {
  description = "Compartment OCID"
  type        = string
}

variable "availability_domain" {
  description = "Availability Domain"
  type        = string
}

variable "subnet_id" {
  description = "Subnet OCID for the instance VNIC"
  type        = string
}

variable "instance_shape" {
  description = "Instance Shape"
  type        = string
}

variable "instance_ocpus" {
  description = "Number of OCPUs for the Flexible Shape"
  type        = number
}

variable "instance_memory_in_gbs" {
  description = "Memory in GBs for the Flexible Shape"
  type        = number
}

variable "ssh_public_key" {
  description = "Public SSH key content for instance access"
  type        = string
  sensitive   = true // Mark as sensitive to avoid showing in logs/output
}

variable "instance_display_name" {
  description = "Instance Display Name"
  type        = string
}

variable "os_image_id" {
  description = "OCID of the OS image to use for the instance"
  type        = string
}

variable "user_data" {
  description = "Cloud-init user data script for instance setup"
  type        = string
  sensitive   = true // Mark as sensitive as it might contain secrets
}

variable "private_security_list_id" {
  description = "OCID of the private security list to associate with the VNIC"
  type        = string
}
