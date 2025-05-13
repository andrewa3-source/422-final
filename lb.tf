resource "google_compute_ssl_certificate" "self_signed" {
  name        = "flask-selfsigned-cert"
  private_key = file("private.key")
  certificate = file("certificate.crt")
}

resource "google_compute_backend_service" "flask_backend" {
  name        = "flask-backend"
  protocol    = "HTTP"
  port_name   = "http"
  timeout_sec = 10

  backend {
    group = google_compute_instance_group.unmanaged_group.self_link
  }

  health_checks = [google_compute_health_check.default.self_link]
}

resource "google_compute_instance_group" "unmanaged_group" {
  name        = "flask-instance-group"
  zone        = var.zone
  instances   = [google_compute_instance.flask-vm.self_link]
  named_port {
    name = "http"
    port = 80
  }
}

resource "google_compute_target_https_proxy" "https_proxy" {
  name             = "https-proxy"
  ssl_certificates = [google_compute_ssl_certificate.self_signed.self_link]
  url_map          = google_compute_url_map.default.self_link
}

resource "google_compute_global_forwarding_rule" "https_rule" {
  name        = "https-forwarding-rule"
  target      = google_compute_target_https_proxy.https_proxy.self_link
  port_range  = "443"
  ip_protocol = "TCP"
  ip_address  = google_compute_global_address.lb_ip.address
}

resource "google_compute_url_map" "default" {
  name            = "flask-url-map"
  default_service = google_compute_backend_service.flask_backend.self_link
}

resource "google_compute_global_address" "lb_ip" {
  name = "flask-lb-ip"
}

resource "google_compute_health_check" "default" {
  name = "flask-health-check"

  http_health_check {
    port = 80
    request_path = "/health"
  }

  check_interval_sec  = 5
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 2
}
