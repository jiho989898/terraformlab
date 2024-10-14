resource "aws_instance" "example" {
    ami = "ami-0ac6b9b2908f3e20d"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.example_subnet_1a.id
    key_name = "testkey"
    associate_public_ip_address = true
    vpc_security_group_ids = [aws_security_group.instance.id]


    user_data = <<-EOF
        #!/bin/bash
        sudo apt update -y
        sudo apt install -y nginx
        echo "Hello All" | sudo tee /var/www/html/index.html
        sudo systemctl start nginx
        echo "Hello All(busybox)" > index.html
        nohup busybox httpd -f -p 8080 &
        EOF
   
    tags = {
        Name = "terraform-example"
    }


    lifecycle {
        create_before_destroy = true
    }
}


resource "aws_security_group" "instance" {
    name = "terraform-example-instance"
    vpc_id = aws_vpc.example.id


    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }


    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }


    ingress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }


    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }
}


output "private_ip" {
    value = aws_instance.example.private_ip
}


output "public_ip" {
    value = aws_instance.example.public_ip
}
