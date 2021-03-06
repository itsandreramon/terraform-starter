data "amazon-ami" "ubuntu" {
  filters = {
    virtualization-type = "hvm"
    root-device-type    = "ebs"
    name                = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
  }

  owners      = ["099720109477"]
  region      = "us-east-2"
  most_recent = true
}

source "amazon-ebs" "ubuntu" {
  source_ami       = data.amazon-ami.ubuntu.id
  ami_name         = "spring-ubuntu"
  instance_type    = "t2.micro"
  ssh_username     = "ubuntu"
  region           = "us-east-2"
  force_deregister = true

  tags = {
    Name = "spring-ubuntu"
  }
}

build {
  name    = "spring-ubuntu"
  sources = ["source.amazon-ebs.ubuntu"]

  provisioner "file" {
    source      = "build/libs/App.jar"
    destination = "~/App.jar"
  }

  provisioner "shell" {
    inline = [
      "sleep 30",
      "sudo apt update",
      "sudo apt -y install openjdk-17-jdk",
    ]
  }
}
