resource "aws_instance" "test" {
    ami = "ami-0e2612a08262410c8"
    instance_type = "t2.micro"
    key_name = "testkey"
    vpc_security_group_ids = ["${aws_security_group.instance.id}"]
     associate_public_ip_address  = true

    user_data = <<-EOF
    #!/bin/bash
    dnf -y install busybox
    echo "Hello	All" > index.html
    nohup busybox httpd -f -p 8080 &
    EOF

    tags = {
        Name = "terraform_test"
    }
}

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"
  
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
    ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
    cidr_blocks       = ["0.0.0.0/0"]
    ipv6_cidr_blocks  = ["::/0"]
  }
}

output public {
  value       = aws_instance.test.public_ip

}
