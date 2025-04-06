# Compute Instance Resource
resource "oci_core_instance" "rocketchat_instance" {
  availability_domain = var.availability_domain
  compartment_id      = var.compartment_ocid
  display_name        = var.instance_display_name
  shape               = var.instance_shape

  # Configuration for Flexible shapes
  shape_config {
    ocpus         = var.instance_ocpus
    memory_in_gbs = var.instance_memory_in_gbs
  }

  # Define the primary Virtual Network Interface Card (VNIC)
  create_vnic_details {
    subnet_id        = var.subnet_id
    display_name     = "${var.instance_display_name}-vnic"
    assign_private_dns_record = true
    assign_public_ip = false
    # security_list_ids = [var.private_security_list_id] // Associate with private security list (Alternative to NSGs)
    # nsg_ids          = [] // Optionally use Network Security Groups instead of Security Lists
  }

  # Define the boot volume source (OS Image)
  source_details {
    source_type = "image"
    source_id   = var.os_image_id
    # Optionally define boot volume size
    # boot_volume_size_in_gbs = 50
  }

  # Instance Metadata including SSH key and cloud-init script
  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    # User data must be base64 encoded
    user_data           = base64encode(var.user_data)
  }

  # Define timeouts for instance creation (adjust as needed)
  timeouts {
    create = "60m"
  }

  # Prevent deletion of the instance if termination protection is enabled (optional)
  # is_pv_encryption_in_transit_enabled = true // Enable in-transit encryption for boot volume
}
