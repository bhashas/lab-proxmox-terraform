terraform {
  cloud {
    organization = "LAB_TEST_BRAHIM"
    workspaces { name = "MON_LAB" }
  }
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      version = "2.9.14"
    }
  }
}

provider "proxmox" {
  pm_api_url          = "https://${var.pve_public_ip}:8006/api2/json"
  pm_api_token_id     = var.pm_token_id
  pm_api_token_secret = var.pm_token_secret
  pm_tls_insecure     = true
}

# --- LOAD BALANCER ---
resource "proxmox_vm_qemu" "lb" {
  name        = "lb-01"
  target_node = "pve-1"
  clone       = "ubuntu-devops" # <--- Vérifie que c'est le nom de ton TEMPLATE
  vmid        = 300
  cores       = 1
  memory      = 1024
  disk {
    size    = "10G"
    type    = "scsi"
    storage = "local-zfs" # <--- J'ai vu 'local-zfs' sur ta photo
  }
  network {
    model = "virtio"
    bridge = "vmbr0"
  }
}

# --- SERVEURS WEB (x2) ---
resource "proxmox_vm_qemu" "web" {
  count       = 2
  name        = "web-0${count.index + 1}"
  target_node = "pve-1"
  clone       = "ubuntu-devops"
  vmid        = 301 + count.index
  cores       = 2
  memory      = 2048
  disk {
    size    = "20G"
    type    = "scsi"
    storage = "local-zfs"
  }
  network {
    model = "virtio"
    bridge = "vmbr0"
  }
}

# --- BASE DE DONNÉES ---
resource "proxmox_vm_qemu" "db" {
  name        = "db-01"
  target_node = "pve-1"
  clone       = "ubuntu-devops"
  vmid        = 303
  cores       = 2
  memory      = 4096
  disk {
    size    = "40G"
    type    = "scsi"
    storage = "local-zfs"
  }
  network {
    model = "virtio"
    bridge = "vmbr0"
  }
}