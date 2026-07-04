# define output block to print values on ip's on terminal 
output "public_ip" {
    value = aws_instance.tf-public-server.public_ip
}

output "private_ip" {
    value = aws_instance.tf-private-server.private_ip
  
}