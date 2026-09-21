packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  # 1. Set the AMI name (Timestamp added to prevent naming collisions)
  ami_name      = "Mahesh-{{timestamp}}"
  instance_type = "t2.micro"
  region        = "us-east-1"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd-gp3/*ubuntu-resolute-26.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
}

build {
  name = "learn-packer"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]

  # 2. Add a provisioner to set the password and enable password login
  provisioner "shell" {
    inline = [
      # Set the password for the 'ubuntu' user (replace 'MySecurePassword' with your desired password)
      "echo 'ubuntu:DevOps321' | sudo chpasswd",

      # Modify SSH config to allow password authentication
      "sudo sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config",
      "sudo sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config.d/*.conf || true",

      # Restart the SSH service to apply changes
      "sudo systemctl restart ssh"
    ]
  }
}