variable "ami"{
    default = "ami-00ca570c1b6d79f36"
}

variable "instance_type"{
    default = "t3.micro"
}

variable "subnets"{
    type = list(string)
}

variable "target_group_arn"{

}

variable "security_group_id"{
    type = string
}