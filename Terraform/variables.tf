variable "project_id" {
  type        = string
  default = "sam-gabrail-gcp-demos"
}

variable "name" {
  type        = string
  default = "gke-consul-vault"
}

variable "region" {
  type        = string
  default = "us-central1"
}

variable "zones" {
  type = list
  default = ["us-central1-a", "us-central1-b", "us-central1-f"]
}

variable "network" {
  type        = string
  default = "sam-network"
}

variable "subnetwork" {
  type        = string
  default = "sam-subnetwork"
}

variable "node_machine_type" {
  type      = string
  default   = "n1-standard-1"
}

variable "node_disk_size" {
  type      = number
  default   = 50
}

variable "node_image_type" {
  type      = string
  default   = "COS"
}

variable "node_count_per_zone" {
  type = number
  default = 1
}