resource "google_storage_bucket" "flask_app_bucket" {
  name = "${random_uuid.uuid.result}"
  location = var.region

  storage_class = "STANDARD"

  force_destroy = true
}

resource "random_uuid" "uuid" {}


resource "google_storage_bucket_iam_member" "public_access" {
  bucket = google_storage_bucket.flask_app_bucket.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}