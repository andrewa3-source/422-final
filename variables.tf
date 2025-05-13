variable "project_id" {
  type        = string
  description = "proj-459616"
}

variable "region" {
  type        = string
  default     = "us-central1"
}

variable "zone" {
  type        = string
  default     = "us-central1-a"
}

variable "db_username" {
  description = "Username to use for the database"
  type = string
  default = "root"
}

variable "db_password" {
  type        = string
  sensitive   = true
  description = "Charizard"
}

variable "github_token" {
  type      = string
  sensitive = true
}

variable "network" {
  default     = "default"  
}

variable "vm_user" {
  description = "Linux user on the VM used for SSH and systemd services"
  type        = string
  default     = "wonkoolkat8"  # or whatever username you use
}

variable "db_name" {
  description = "Name of the database to use"
  type = string
  default = "gallery"
}