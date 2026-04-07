variable "access_key" {
  description = "ID de la llave de acceso de AWS"
  type        = string
  sensitive   = true
}

variable "secret_access_key" {
  description = "Llave secreta de acceso de AWS"
  type        = string
  sensitive   = true
}