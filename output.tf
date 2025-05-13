output "vm_ip" {
  value = google_compute_instance.flask-vm.network_interface[0].access_config[0].nat_ip
}

output "db_connection_name" {
  value = google_sql_database_instance.default.connection_name
}

output "bucket_name" {
  value = google_storage_bucket.flask_app_bucket.name
}

output "bucket_url" {
  value = google_storage_bucket.flask_app_bucket.url
}