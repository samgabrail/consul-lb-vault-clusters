resource "google_compute_subnetwork" "my-subnetwork" {
  name          = var.subnetwork 
  project = var.project_id
  ip_cidr_range = "10.2.0.0/16"
  region        = var.region
  network       = google_compute_network.my-network.id
  secondary_ip_range {
    range_name    = "pods"
    ip_cidr_range = "192.168.16.0/20"
  }
   secondary_ip_range {
    range_name    = "services"
    ip_cidr_range = "192.168.32.0/20"
  }
}

resource "google_compute_network" "my-network" {
  name                    = var.network
  auto_create_subnetworks = false
  project = var.project_id
}

module "gke" {
    depends_on = [
      google_compute_network.my-network, google_compute_subnetwork.my-subnetwork
    ]
  source                     = "terraform-google-modules/kubernetes-engine/google"
  version = "v15.0.2"
  project_id                 = var.project_id
  name                       = var.name
  region                     = var.region
  zones                      = var.zones
  network                    = google_compute_network.my-network.name
  subnetwork                 = google_compute_subnetwork.my-subnetwork.name
  ip_range_pods              = google_compute_subnetwork.my-subnetwork.secondary_ip_range.0.range_name
  ip_range_services          = google_compute_subnetwork.my-subnetwork.secondary_ip_range.1.range_name
  http_load_balancing        = false
  horizontal_pod_autoscaling = true
#   kubernetes_dashboard       = true
  network_policy             = true

  node_pools = [
    {
      name               = "default-node-pool"
      machine_type       = var.node_machine_type
      min_count          = 1
      max_count          = 3
      disk_size_gb       = var.node_disk_size
      disk_type          = "pd-standard"
      image_type         = var.node_image_type
      auto_repair        = true
      auto_upgrade       = true
    #   service_account    = "project-service-account@<PROJECT ID>.iam.gserviceaccount.com"
      preemptible        = false
      initial_node_count = var.node_count_per_zone
    },
  ]

  node_pools_oauth_scopes = {
    all = []

    default-node-pool = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  node_pools_labels = {
    all = {}

    default-node-pool = {
      default-node-pool = true
    }
  }

  node_pools_metadata = {
    all = {}

    default-node-pool = {
      node-pool-metadata-custom-value = "my-node-pool"
    }
  }

  node_pools_taints = {
    all = []

    default-node-pool = [
      {
        key    = "default-node-pool"
        value  = true
        effect = "PREFER_NO_SCHEDULE"
      },
    ]
  }

  node_pools_tags = {
    all = []

    default-node-pool = [
      "default-node-pool",
    ]
  }
}