output "bosh_private_subnet" {
  value = aws_subnet.bosh_private_subnet.id
}

output "bosh_private_key_name" {
  value = module.key_pair.key_pair_key_name
}

output "bosh_private_key" {
  value = tls_private_key.this.private_key_pem
  sensitive = true
}