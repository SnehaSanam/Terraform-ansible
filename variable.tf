variable "ec2_instance_type" {
    default = "t2.micro"
    type = string
}

variable "ec2_root_storage_size" {
    default = 15
    type = number
}

variable "ec2_ami_id" {
    default = "ami-03fd334507439f4d1"
    type = string
}
