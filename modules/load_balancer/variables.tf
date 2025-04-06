variable "compartment_ocid" {
  description = "Compartment OCID"
  type        = string
}

variable "lb_display_name" {
  description = "Load Balancer Display Name"
  type        = string
}

variable "subnet_id" {
  description = "Public Subnet OCID for the Load Balancer"
  type        = string
}

variable "instance_private_ip" {
  description = "Private IP of the backend instance"
  # Allow null value initially as it depends on compute module output
  type        = string
  default     = null
}

variable "instance_port" {
  description = "Port the backend instance is listening on (RocketChat port)"
  type        = number
}

variable "public_security_list_id" {
  description = "OCID of the public security list (used by LB subnet)"
  type        = string
}
