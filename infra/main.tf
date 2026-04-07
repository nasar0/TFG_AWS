# --- SERVIDOR 1: FRONTEND (React) ---
resource "aws_instance" "frontend" {
  ami           = "ami-0c55b159cbfafe1f0" # Amazon Linux 2023
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet.id
  
  # ASIGNACIÓN: Usamos el SG de Frontend (Abierto al público)
  vpc_security_group_ids = [aws_security_group.sg_frontend.id]
  
  key_name      = "tu-clave-aws" # El nombre de tu .pem sin la extensión

  user_data = <<-EOF
              #!/bin/bash
              dnf update -y
              dnf install -y docker
              systemctl start docker
              systemctl enable docker
              curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
              chmod +x /usr/local/bin/docker-compose
              EOF

  tags = { Name = "TFG-Frontend-React" }
}

# --- SERVIDOR 2: BACKEND (PHP + API) ---
resource "aws_instance" "backend" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet.id
  
  # ASIGNACIÓN: Usamos el SG de Backend (Solo acepta llamadas del Frontend)
  vpc_security_group_ids = [aws_security_group.sg_backend.id]
  
  key_name      = "tu-clave-aws"

  user_data = <<-EOF
              #!/bin/bash
              dnf update -y
              dnf install -y docker
              systemctl start docker
              systemctl enable docker
              curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
              chmod +x /usr/local/bin/docker-compose
              EOF

  tags = { Name = "TFG-Backend-PHP" }
}