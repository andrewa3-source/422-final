resource "google_sql_database_instance" "default" {
  name             = "flask-mysql-db"
  database_version = "MYSQL_8_0"
  region           = var.region

  depends_on = [google_service_networking_connection.private_vpc_connection]

  settings {
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled                                  = false
      private_network                               = google_compute_network.vpc_network.self_link
      enable_private_path_for_google_cloud_services = true
    }
  }
}

resource "google_project_service" "sqladmin" {
  project = var.project_id
  service = "sqladmin.googleapis.com"
}

resource "google_sql_database" "app_db" {
  instance = google_sql_database_instance.default.name
  name     = var.db_name
}

resource "google_sql_user" "app_user" {
  instance    = google_sql_database_instance.default.name
  name        = var.db_username
  password = var.db_password
}