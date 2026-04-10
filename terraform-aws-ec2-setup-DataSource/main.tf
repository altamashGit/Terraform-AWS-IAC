data "aws_vpc" "default" {
    default = true
}

data "aws_subnet" "selected" {
    id = var.subnet_id
}

data "aws_ami" "k8s" {
    owners = ["self"]
    most_recent = true
    filter {
    name   = "name"
    values = ["kubernetes-ami"]
  }
}

resource "aws_instance" "web_site"{
    ami = data.aws_ami.k8s.id
    instance_type = var.instance_type
    subnet_id = data.aws_subnet.selected.id
    tags = {
        Name = "web-server-terra"
    }
} 