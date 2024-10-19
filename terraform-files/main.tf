resource "aws_instance" "test-server" {
  ami = "ami-06b21ccaeff8cd686"
  instance_type = "t2.micro"
  key_name = "bankingpro"
  vpc_security_group_ids = ["sg-0fdf7240fc49b5bef"]
  connection {
     type = "ssh"
     user = "ec2-user"
     private_key = file("./bankingpro.pem")
     host = self.public_ip
     }
  provisioner "remote-exec" {
     inline = ["echo 'wait to start the instance' "]
  }
  tags = {
     Name = "test-server"
     }
  provisioner "local-exec" {
     command = "echo ${aws_instance.test-server.public_ip} > inventory"
     }
  provisioner "local-exec" {
     command = "ansible-playbook /var/lib/jenkins/workspace/BankingProject/terraform-files/ansibleplaybook.yml"
     }
  }
