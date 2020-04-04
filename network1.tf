# Create the network1
resource "google_compute_network" "network1" {
  name                    = "network1"
  auto_create_subnetworks = true
}

# Create a firewall rule to allow HTTP, SSH, RDP and ICMP traffic on network1
resource "google_compute_firewall" "network1_allow_http_ssh_rdp_icmp" {
  name    = "network1-allow-http-ssh-rdp-icmp"
  network = "${google_compute_network.network1.self_link}"

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "3389"]
  }

  allow {
    protocol = "icmp"
  }
}

# Create the network1-us-vm instance
module "network1-us-vm" {
  source              = "./instance"
  instance_name       = "network1-us-vm"
  instance_zone       = "us-central1-a"
  instance_subnetwork = "${google_compute_network.network1.self_link}"
}

# Create the network1-eu-vm" instance
module "network1-eu-vm" {
  source              = "./instance"
  instance_name       = "network1-eu-vm"
  instance_zone       = "europe-west1-d"
  instance_subnetwork = "${google_compute_network.network1.self_link}"
}
