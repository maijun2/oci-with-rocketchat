# Flexible Load Balancer Resource
resource "oci_load_balancer_load_balancer" "rocketchat_lb" {
  compartment_id = var.compartment_ocid
  display_name   = var.lb_display_name
  shape          = "flexible" // Use the flexible shape

  # Define the minimum and maximum bandwidth for the flexible shape
  shape_details {
    minimum_bandwidth_in_mbps = 10
    maximum_bandwidth_in_mbps = 10
  }

  # Associate the Load Balancer with the public subnet
  subnet_ids = [var.subnet_id]

  # Optionally associate with Network Security Groups
  # network_security_group_ids = []

  # Ensure this is a public Load Balancer
  is_private = false
}

# Backend Set for HTTP traffic
resource "oci_load_balancer_backend_set" "http_backend_set" {
  name             = "rocketchat-http-bs"
  load_balancer_id = oci_load_balancer_load_balancer.rocketchat_lb.id
  policy           = "ROUND_ROBIN"

  # Health Check configuration for backend instances
  health_checker {
    protocol = "HTTP"
    port     = var.instance_port
    url_path = "/"
    interval_ms = 10000
    timeout_in_millis = 3000
    retries = 3
    return_code = 200
  }

  # Optional SSL configuration if terminating SSL at the Load Balancer
  # ssl_configuration {
  #   certificate_name = oci_load_balancer_certificate.example_certificate.name // Reference your certificate resource
  #   verify_depth = 1
  #   verify_peer_certificate = true
  # }
}

# Backend resource representing the RocketChat instance
resource "oci_load_balancer_backend" "instance_backend" {
  load_balancer_id = oci_load_balancer_load_balancer.rocketchat_lb.id
  backendset_name  = oci_load_balancer_backend_set.http_backend_set.name
  ip_address       = var.instance_private_ip
  port             = var.instance_port
  backup           = false
  drain            = false
  offline          = false
  weight           = 1
}

# Listener for incoming HTTP traffic on port 80
resource "oci_load_balancer_listener" "http_listener" {
  load_balancer_id         = oci_load_balancer_load_balancer.rocketchat_lb.id
  name                     = "http_listener"
  default_backend_set_name = oci_load_balancer_backend_set.http_backend_set.name
  port                     = 80
  protocol                 = "HTTP"

  # Optional: Connection configuration
  # connection_configuration {
  #   idle_timeout_in_seconds = 60
  # }

  # Optional: Rule sets for advanced routing
  # rule_set_names = []

  # Optional: Hostname routing
  # hostname_names = []
}

