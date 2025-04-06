variable "tenancy_ocid" {
  description = "OCI Tenancy OCID (Needed for looking up Availability Domain)"
  type        = string
  # default     = "ocid1.tenancy.oc1..xxxxx" # 環境変数 TF_VAR_tenancy_ocid または terraform.tfvars で設定推奨
}

variable "compartment_ocid" {
  description = "Compartment OCID where resources will be created"
  type        = string
  # default     = "ocid1.compartment.oc1..xxxxx" # 環境変数 TF_VAR_compartment_ocid または terraform.tfvars で設定推奨
}

variable "region" {
  description = "OCI region"
  type        = string
  default     = "eu-frankfurt-1"
}

variable "ssh_public_key_path" {
  description = "Path to the public SSH key file"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

# インスタンスシェイプ用の変数
variable "instance_shape" {
  description = "Compute instance shape"
  type        = string
  default     = "VM.Standard.E4.Flex" # デフォルトを E4.Flex に設定
}

variable "instance_ocpus" {
  description = "Number of OCPUs for the compute instance"
  type        = number
  default     = 1
}

variable "instance_memory_in_gbs" {
  description = "Amount of memory in GBs for the compute instance"
  type        = number
  default     = 16 # VM.Standard.E4.Flex は最低16GB必要
}

variable "vcn_cidr_block" {
  description = "CIDR block for the VCN"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr_block" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr_block" {
  description = "CIDR block for the private subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "instance_display_name" {
  description = "Display name for the compute instance"
  type        = string
  default     = "rocketchat-instance"
}

variable "load_balancer_display_name" {
  description = "Display name for the load balancer"
  type        = string
  default     = "rocketchat-lb"
}

variable "rocketchat_port" {
  description = "Internal port for RocketChat service"
  type        = number
  default     = 3000
}

variable "os_version" {
  description = "Operating system version for Ubuntu image (e.g., 22.04)"
  type        = string
  default     = "22.04" # 最新のLTS推奨
}
