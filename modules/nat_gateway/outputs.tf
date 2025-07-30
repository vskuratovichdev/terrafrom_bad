output "nat_gateway_id" {
  description = "The ID of the NAT Gateway"
  value       = azurerm_nat_gateway.this.id
}

output "public_ip_id" {
  description = "The ID of the Public IP associated with the NAT Gateway"
  value       = azurerm_public_ip.nat.id
}

output "public_ip_address" {
  description = "The Public IP address of the NAT Gateway"
  value       = azurerm_public_ip.nat.ip_address
} 