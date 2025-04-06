output "vcn_id" {
  description = "The OCID of the VCN"
  value = oci_core_vcn.rocketchat_vcn.id
}

output "public_subnet_id" {
  description = "The OCID of the public subnet"
  value = oci_core_subnet.public_subnet.id
}

output "private_subnet_id" {
  description = "The OCID of the private subnet"
  value = oci_core_subnet.private_subnet.id
}

output "public_security_list_id" {
  description = "The OCID of the public security list"
  value = oci_core_security_list.public_sl.id
}

output "private_security_list_id" {
  description = "The OCID of the private security list"
  value = oci_core_security_list.private_sl.id
}
