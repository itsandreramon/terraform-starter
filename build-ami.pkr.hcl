packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "spring-ubuntu"
  source_ami    = "ami-0fb653ca2d3203ac1"
  instance_type = "t2.micro"
  region        = "us-east-2"
  ssh_username  = "ubuntu"
}

build {
  name    = "spring-ubuntu"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]

  provisioner "file" {
    source      = "build/libs/App.jar"
    destination = "~/App.jar"
  }

  provisioner "shell" {
    inline = [
      "sleep 30",
      "sudo apt update",
      "sudo apt -y install openjdk-17-jdk",
      "sudo rm -Rf /var/lib/cloud/data/scripts",
      "sudo rm -Rf /var/lib/cloud/scripts/per-instance",
      "sudo rm -Rf /var/lib/cloud/data/user-data*",
      "sudo rm -Rf /var/lib/cloud/instances/*",
      "sudo rm -Rf /var/lib/cloud/instance",
    ]
  }
}