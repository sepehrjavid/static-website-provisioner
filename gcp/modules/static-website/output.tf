output "lb_ip" {
  value       = google_compute_global_address.default.address
  description = "IP address to reach the website"
}
