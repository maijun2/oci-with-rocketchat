# Virtual Cloud Network (VCN)
resource "oci_core_vcn" "rocketchat_vcn" {
  compartment_id = var.compartment_ocid
  cidr_block     = var.vcn_cidr_block
  display_name   = "rocketchat-vcn"
  dns_label      = "rocketchatvcn"
}

# Internet Gateway (IGW) for public subnet communication
resource "oci_core_internet_gateway" "igw" {
  compartment_id = var.compartment_ocid
  display_name   = "rocketchat-igw"
  vcn_id         = oci_core_vcn.rocketchat_vcn.id
}

# NAT Gateway (NGW) for private subnet outbound communication
resource "oci_core_nat_gateway" "ngw" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.rocketchat_vcn.id
  display_name   = "rocketchat-ngw"
}

# Route Table for the Public Subnet (routes traffic to IGW)
resource "oci_core_route_table" "public_rt" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.rocketchat_vcn.id
  display_name   = "rocketchat-public-rt"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.igw.id
  }
}

# Route Table for the Private Subnet (routes traffic to NGW)
resource "oci_core_route_table" "private_rt" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.rocketchat_vcn.id
  display_name   = "rocketchat-private-rt"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_nat_gateway.ngw.id
  }
}

# Security List for the Public Subnet
resource "oci_core_security_list" "public_sl" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.rocketchat_vcn.id
  display_name   = "rocketchat-public-sl"

  // Allow all egress traffic (stateful rules handle return traffic)
  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
  }

  // Allow incoming HTTP traffic on port 80 from anywhere for the Load Balancer
  ingress_security_rules {
    protocol = "6" // TCP
    source   = "0.0.0.0/0"
    tcp_options {
      max = 80
      min = 80
    }
    description = "Allow HTTP from anywhere to LB"
  }

  # Add rule for SSH if needed (restrict source IP for security)
  #ingress_security_rules {
  #  protocol = "6" // TCP
  #  source   = "YoureIP/32" // Replace with your IP/CIDR
  #  tcp_options {
  #    max = 22
  #    min = 22
  #  }
  #  description = "Allow SSH from management IP"
  #}
}

# Security List for the Private Subnet
resource "oci_core_security_list" "private_sl" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.rocketchat_vcn.id
  display_name   = "rocketchat-private-sl"

  // Allow all egress traffic for updates, snap installs etc. via NAT Gateway
  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
  }

  // Allow incoming traffic from the Load Balancer (Public Subnet CIDR) on RocketChat port
  ingress_security_rules {
    protocol = "6" // TCP
    source   = var.public_subnet_cidr_block // Allow traffic only from the public subnet
    tcp_options {
      max = var.rocketchat_port
      min = var.rocketchat_port
    }
    description = "Allow RocketChat traffic from Load Balancer"
  }

  # Add rule for SSH if needed (e.g., from Bastion or specific IPs)
  # ingress_security_rules {
  #   protocol = "6" // TCP
  #   source   = "YOUR_BASTION_IP/32" // Replace with Bastion IP/CIDR
  #   tcp_options {
  #     max = 22
  #     min = 22
  #   }
  #   description = "Allow SSH from Bastion"
  # }

  # Allow traffic within the same private subnet (optional, for multi-instance setups)
  ingress_security_rules {
   protocol = "6" //TCP
   source   = var.public_subnet_cidr_block
   tcp_options {
      max = 22
      min = 22
   }
   description = "Allow traffic within private subnet"
  }
}

# Public Subnet
resource "oci_core_subnet" "public_subnet" {
  #availability_domain = var.availability_domain_name
  compartment_id      = var.compartment_ocid
  cidr_block          = var.public_subnet_cidr_block
  display_name        = "rocketchat-public-subnet"
  vcn_id              = oci_core_vcn.rocketchat_vcn.id
  route_table_id      = oci_core_route_table.public_rt.id
  security_list_ids   = [oci_core_security_list.public_sl.id]
  dns_label           = "public" // Required for DNS resolution within VCN
}

# Private Subnet
resource "oci_core_subnet" "private_subnet" {
  #availability_domain = var.availability_domain_name
  compartment_id      = var.compartment_ocid
  cidr_block          = var.private_subnet_cidr_block
  display_name        = "rocketchat-private-subnet"
  vcn_id              = oci_core_vcn.rocketchat_vcn.id
  route_table_id      = oci_core_route_table.private_rt.id
  security_list_ids   = [oci_core_security_list.private_sl.id]
  prohibit_public_ip_on_vnic = true // No public IPs assigned to instances in this subnet
  dns_label           = "private" // Required for DNS resolution within VCN
}
