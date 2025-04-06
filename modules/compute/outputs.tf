output "instance_id" {
  description = "The OCID of the created compute instance"
  value = oci_core_instance.rocketchat_instance.id
}

output "instance_private_ip" {
  description = "The private IP address of the compute instance"
  # Use try() to handle cases where the IP might not be immediately available
  value = try(oci_core_instance.rocketchat_instance.private_ip, null)
}
