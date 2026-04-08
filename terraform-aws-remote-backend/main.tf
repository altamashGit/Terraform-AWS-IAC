
#1. Key pair for EC2 instance state
resource "aws_key_pair" "instance_key_pair" {
    key_name  = "state_key_pair"
    public_key = file("c:/users/altam/.ssh/id_ed25519.pub")
}


#2. Security group for EC2 instance state
resource "aws_security_group" "ec2_instance_state-sg" {
    name        = "ec2_instance_state"
    description = "Security group for EC2 instance state"

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

#3. Default VPC data source
data "aws_vpc" "default" {
    default = true
}
# 4. EC2 instance for EC2 instance state 
resource "aws_instance" "ec2_instance_state" {
    ami                    = "ami-05d2d839d4f73aafb"
    instance_type          = "t2.micro"
    key_name               = aws_key_pair.instance_key_pair.key_name
    vpc_security_group_ids = [aws_security_group.ec2_instance_state-sg.id]

    root_block_device {
        volume_size = 8
        volume_type = "gp2"
    }

    tags = {
        Name = "ec2_instance_state"
    }
}