output "load_balancer_id" {
  description = "The OCID of the Load Balancer"
  value = oci_load_balancer_load_balancer.rocketchat_lb.id
}

output "load_balancer_public_ip" {
  description = "The public IP address of the load balancer"
  value = try(oci_load_balancer_load_balancer.rocketchat_lb.ip_address_details[0].ip_address, null)

}

output "backend_set_name" {
  description = "The name of the HTTP backend set"
  value = oci_load_balancer_backend_set.http_backend_set.name
}
