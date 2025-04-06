output "load_balancer_public_ip" {
  description = "Public IP address of the Load Balancer"
  value       = module.load_balancer.load_balancer_public_ip
}

output "instance_private_ip" {
  description = "Private IP address of the RocketChat instance"
  value       = module.compute.instance_private_ip
}
