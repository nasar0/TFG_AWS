# Salida para la IP del Frontend
output "ip_frontend" {
  description = "Dirección IP pública del servidor React"
  value       = aws_instance.frontend.public_ip
}

# Salida para la IP del Backend
output "ip_backend" {
  description = "Dirección IP pública del servidor PHP"
  value       = aws_instance.backend.public_ip
}