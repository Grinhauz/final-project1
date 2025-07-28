data "aws_vpc" "this" {
  id = "vpc-044604d0bfb707142"
}


# data "aws_ami" "ubuntu" {

#  filter {
#    name   = "image-id"
#    values = ["ami-0c02fb55956c7d316"]
#  }


#  filter {
#    name   = "virtualization-type"
#    values = ["hvm"]
#  }
# }