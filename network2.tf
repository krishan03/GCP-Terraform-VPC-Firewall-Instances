# Create the network2
resource "google_compute_network" "network2" {
  name                    = "network2"
  auto_create_subnetworks = "false"
}

# Create network2subnet-us subnetwork
resource "google_compute_subnetwork" "network2subnet-us" {
  name          = "network2subnet-us"
  region        = "us-central1"
  network       = "${google_compute_network.network2.self_link}"
  ip_cidr_range = "10.130.0.0/20"
}

# Add a firewall rule to allow HTTP, SSH, and RDP traffic on network2
resource "google_compute_firewall" "network2-allow-http-ssh-rdp-icmp" {
  name    = "network2-allow-http-ssh-rdp-icmp"
  network = "${google_compute_network.network2.self_link}"

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "3389"]
  }

  allow {
    protocol = "icmp"
  }
}

# Add the network2-us-vm instance
module "network2-us-vm" {
  source              = "./instance"
  instance_name       = "network2-us-vm"
  instance_zone       = "us-central1-a"
  instance_subnetwork = "${google_compute_subnetwork.network2subnet-us.self_link}"
}
