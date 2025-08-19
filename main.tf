terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">= 7.0.0"
    }
  }
}

provider "oci" {
  region = var.region
}

data "oci_identity_availability_domain" "ad" {
  # ADの検索にはテナンシーOCIDが必要
  compartment_id = var.tenancy_ocid
  ad_number      = 1  # 1番目のADを取得（必要に応じて変更）
}


# 最新の Ubuntu イメージを取得
data "oci_core_images" "ubuntu_image" {
  compartment_id           = var.compartment_ocid # イメージがあるコンパートメントを指定
  operating_system         = "Canonical Ubuntu"
  operating_system_version = var.os_version
  shape                    = var.instance_shape    # 変数を使用
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

locals {
  ssh_public_key = file(pathexpand(var.ssh_public_key_path))
  user_data      = templatefile("${path.module}/cloud_init.tpl", {})
}

module "network" {
  source = "./modules/network"

  compartment_ocid         = var.compartment_ocid
  vcn_cidr_block           = var.vcn_cidr_block
  public_subnet_cidr_block = var.public_subnet_cidr_block
  private_subnet_cidr_block= var.private_subnet_cidr_block
  rocketchat_port          = var.rocketchat_port
}

module "compute" {
  source = "./modules/compute"

  compartment_ocid        = var.compartment_ocid
  availability_domain     = data.oci_identity_availability_domain.ad.name
  subnet_id               = module.network.private_subnet_id
  instance_shape          = var.instance_shape
  instance_ocpus          = var.instance_ocpus
  instance_memory_in_gbs  = var.instance_memory_in_gbs
  ssh_public_key          = local.ssh_public_key
  instance_display_name   = var.instance_display_name
  os_image_id             = data.oci_core_images.ubuntu_image.images[0].id
  user_data               = local.user_data
  private_security_list_id= module.network.private_security_list_id

  # モジュールがイメージデータソースの完了を待つように依存関係を設定
  depends_on = [data.oci_core_images.ubuntu_image]
}

module "load_balancer" {
   
  source = "./modules/load_balancer"

  compartment_ocid         = var.compartment_ocid
  lb_display_name          = var.load_balancer_display_name
  subnet_id                = module.network.public_subnet_id
  instance_private_ip      = module.compute.instance_private_ip
  instance_port            = var.rocketchat_port
  public_security_list_id  = module.network.public_security_list_id

  # LBがコンピュートモジュールの完了 (インスタンス作成とIP確定) を待つように依存関係を設定
  depends_on = [module.compute]
}
