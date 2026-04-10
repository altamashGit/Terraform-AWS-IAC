output "subnet_id" {
    value = "aws_subnet.selected.id"
}

output "image_id" {
    value = aws_instance.web_site.ami
}