variable "sg_name" {
    type = string
    default = "Guy_SG"
}

variable "sg_description" {
    type = string
    default = "Guy's securoty group"
}

variable "vpc_name" {
    type = string
    default = "vpc-044604d0bfb707142 "
    description = "name of VPC"
  
}

variable "cidr_ipv4" {
    type = string
    default = "10.0.101.0/24"

}
variable "from_port" {
    type = number 
    default = 22
    
  
}

variable "ip_protocol" {
    type = string
    default = "TCP"

}

variable "to_port" {
    type = number
    default = 22
    

}

variable "instance_type" {
    type = string  
    default = "t3-medium"

}

variable "key_name" {
    type = string
    default = "guy-tf-keypair"
  
}

variable "aws_access_key" {
  default = "AKIAXLEKZJVVREN3MIWD"
  type        = string
  sensitive   = true
}

variable "aws_secret_key" {
  default = "x9mxe6NVYyJlOFs9I0agMYd5o6yk2zv+kug/9EQu"
  type        = string
  sensitive   = true
}
