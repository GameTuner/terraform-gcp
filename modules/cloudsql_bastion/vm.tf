resource "google_compute_instance" "vm" {
  name         = "cloudsql-bastion-${var.name}"
  machine_type = "f1-micro"

  boot_disk {
    initialize_params {
      image = "ubuntu-2004-focal-v20230213"
    }
  }

  zone = var.zone

  network_interface {
    network = var.network_name
    subnetwork = var.subnetwork_name
  }

  service_account {
    email  = var.service_account_email
    scopes = ["cloud-platform"]
  }

  metadata = {
    startup-script = <<EOF
#!/bin/bash

wget https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 -O cloud_sql_proxy
chmod +x cloud_sql_proxy

./cloud_sql_proxy -instances="${var.instance_connection_name}"=tcp:5432 &

sudo apt-get update
sudo apt-get install -y postgresql-client

echo "PGPASSWORD=${var.database_password} psql -h localhost -p 5432 -U ${var.database_username} -d ${var.database_name}" >> /usr/bin/connect_to_db.sh
chmod +x /usr/bin/connect_to_db.sh
EOF
  }
}