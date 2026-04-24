variable "bucket_name" {
    description = "The nam of the s3 bucket to create"
    type    = string
    default = "project.altamash.cloud"
}

variable "file_path" {
    description = "The path to the file "
    type = string
    default = "www"
}

variable "my_domain"{
    description = "The domain name to use for cfn distribution"
    type = string
    default = "altamash.cloud"
}