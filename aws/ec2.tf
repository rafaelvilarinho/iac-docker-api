resource "aws_instance" "vmexample" {
  ami           = "ami-0e66f5495b4efdd0f"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.generated_key.key_name
  vpc_security_group_ids = [aws_security_group.allow_api.id]
  
  depends_on = [ 
    aws_default_vpc.main,
    aws_security_group.allow_api,
    tls_private_key.main
  ]

  provisioner "file" {
    source      = "./scripts/aws-ec2-setup.sh"
    destination = "/tmp/aws-ec2-setup.sh"
  }

  provisioner "file" {
    source      = "./scripts/public_keys"
    destination = "/tmp/public_keys"
  }

  provisioner "remote-exec" {
    inline = [
      "cat /tmp/public_keys >> ~/.ssh/authorized_keys",
      "chmod +x /tmp/aws-ec2-setup.sh",
      "sudo /tmp/aws-ec2-setup.sh",
    ]
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    password    = ""
    private_key = tls_private_key.main.private_key_pem
    host        = self.public_ip
  }

  tags = {
    "Name"        = "vm-example",
    "iaas-engine" = "terraform"
  }
}

output "vmexample-public-ip" {
  depends_on = [aws_instance.vmexample]
  description = "VM Example Public IP"
  value = aws_instance.vmexample.public_ip
}