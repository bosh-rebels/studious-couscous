output "bosh_private_subnet" {
  value = aws_subnet.bosh_private_subnet.id
}

output "bosh_key" {
  value = key_pair
}