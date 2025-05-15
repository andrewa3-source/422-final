resource "google_compute_instance" "final-422" {
  name         = "final-422"
  machine_type = "e2-standard-2"
  zone         = var.zone
  tags         = ["ssh", "http-server"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-minimal-2410-amd64"
    }
  }

  metadata_startup_script = file("./gallery/start.sh")

  metadata = {
    "BUCKET_NAME" = google_storage_bucket.flask_app_bucket.name
    "DB_USERNAME" = var.db_username
    "DB_PASSWORD" = var.db_password
    "DB_NAME"     = var.db_name
    "DB_CONN"     = google_sql_database_instance.default.connection_name
  }

  service_account {
    scopes = ["cloud-platform"]
  }

  network_interface {
    network = google_compute_network.vpc_network.id
    subnetwork = google_compute_subnetwork.default.id
    access_config {}
  }
}