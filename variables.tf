variable "pm_token_id" {
  description = "ID du Token Proxmox"
  type        = string
  sensitive   = true
}

variable "pm_token_secret" {
  description = "Secret du Token Proxmox"
  type        = string
  sensitive   = true
}

variable "pve_public_ip" {
  description = "IP publique du serveur Proxmox"
  type        = string
}