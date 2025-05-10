resource "google_compute_network" "managementnet" {
  name                    = "managementnet"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "managementsubnet-us" {
  name          = "managementsubnet-us"
  region        = "europe-west1"
  network       = google_compute_network.managementnet.self_link
  ip_cidr_range = "10.130.0.0/20"

}

resource "google_compute_firewall" "managementnet-allow-http-ssh-rdp-icmp" {
  name          = "managementnet-allow-http-ssh-rdp-icmp"
  source_ranges = ["0.0.0.0/0"]
  network       = google_compute_network.managementnet.self_link
  allow {
    protocol = "tcp"
    ports    = ["22", "80", "3389"]
  }
  allow {
    protocol = "icmp"
  }

}
module "managementnet-us-vm" {
  source              = "./instance"
  instance_name       = "managementnet-us-vm"
  instance_zone       = "europe-west1-c"
  instance_subnetwork = google_compute_subnetwork.managementsubnet-us.self_link

}
