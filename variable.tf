# define variable block to pass the values dynamically 

variable "vpc_cidr" {
  default     = "10.0.0.0/16"
}

variable "private_cidr" {
    default = "10.0.0.0/20" 
}

variable "public_cidr" {
  default = "10.0.16.0/20"
}

variable "az1" {
    default = "eu-north-1a"
}

variable "az2" {
    default = "eu-north-1b"
}

variable "project" {         # used variable as prefix
    default = "FCT"
}

variable "public_RT_cidr" {
    default = "0.0.0.0/0"
}

variable "ami" {
    default = "ami-0402e980e69d5978b"
}

variable "instance_type" {
    default = "t3.micro"
}

variable "key" {
    default = "kia"
  
}