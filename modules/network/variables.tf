variable "compartment_ocid" {
  description = "Compartment OCID"
  type        = string
}

variable "vcn_cidr_block" {
  description = "VCN CIDR block"
  type        = string
}

variable "public_subnet_cidr_block" {
  description = "Public Subnet CIDR block"
  type        = string
}

variable "private_subnet_cidr_block" {
  description = "Private Subnet CIDR block"
  type        = string
}

variable "rocketchat_port" {
  description = "Internal port for RocketChat service"
  type        = number
}
