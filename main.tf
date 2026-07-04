# define terraform backend to store state file in s3 bucket
terraform {
  backend "s3" {
    bucket = "terraform-2-tire-project-backet-bucket"
    key    = "terraform.tfstate"
    region = "eu-north-1" 
  }
}

# define provider and resources to create 2-tier architecture in aws
provider "aws" {
  region = "eu-north-1"
}

# define vpc
resource "aws_vpc" "tf-vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "${var.project}-vpc"
  }
}

# define private subnet
resource "aws_subnet" "tf-private-subnet" {
  vpc_id         = aws_vpc.tf-vpc.id
  cidr_block     = var.private_cidr
  availability_zone = var.az1
  tags = {
    Name = "${var.project}-private-subnet"
  }
}   


# define public subnet
resource "aws_subnet" "tf-public-subnet" {
    vpc_id         = aws_vpc.tf-vpc.id
    cidr_block     = var.public_cidr
    availability_zone = var.az2
    map_public_ip_on_launch = true  # auto assign ip enable 
    tags = {
      Name = "${var.project}-public-subnet"
    }
}

# define internet gateway
resource "aws_internet_gateway" "tf-igw" {
    vpc_id = aws_vpc.tf-vpc.id
    tags = {
      Name = "${var.project}-igw"
    }
}

# rename default rt 
resource "aws_default_route_table" "main-rt" {
    default_route_table_id = aws_vpc.tf-vpc.default_route_table_id
    tags ={
        Name = "${var.project}-public-rt"
    }
}

# add ige entry to default rt 
resource "aws_route" "tf-route" {
    route_table_id = aws_default_route_table.main-rt.id
    destination_cidr_block = var.public_RT_cidr 
    gateway_id = aws_internet_gateway.tf-igw.id
}

# define security group
resource "aws_security_group" "tf-sg" {
    name = "${var.project}-sg"
    description = "allow ssh, tomcat, http, mysql traffic"
    vpc_id = aws_vpc.tf-vpc.id
    ingress  {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

     ingress  {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

     ingress  {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

     ingress  {
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress  {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    depends_on = [ aws_vpc.tf-vpc ]
}

# define public server
resource "aws_instance" "tf-public-server" {
     subnet_id = aws_subnet.tf-public-subnet.id
     ami = var.ami
     instance_type = var.instance_type
     key_name  =  var.key
     vpc_security_group_ids = [aws_security_group.tf-sg.id]
     tags = {
       Name = "${var.project}-proxy-server"
     }

     depends_on = [ aws_security_group.tf-sg ]
}


# define private server
resource "aws_instance" "tf-private-server" {
     subnet_id = aws_subnet.tf-private-subnet.id
     ami = var.ami
     instance_type = var.instance_type
     key_name  =  var.key
     vpc_security_group_ids = [aws_security_group.tf-sg.id]
     tags = {
       Name = "${var.project}-app-server"
     }

     depends_on = [ aws_security_group.tf-sg ]
}