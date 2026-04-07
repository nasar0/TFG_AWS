data "aws_ami" "aws_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*-x86_64"]
  }
}
resource "aws_instance" "app" {
  ami           = data.aws_ami.aws_ami.id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet.id
  
  # Usamos el SG de Frontend para que sea accesible desde fuera (puerto 80/443)
  vpc_security_group_ids = [aws_security_group.sg_frontend.id]
  
  key_name      = "aws_key_tfg"

  user_data = <<-EOT
    #!/bin/bash
    # 1. Preparar el sistema e instalar git
    dnf update -y
    dnf install -y docker git
    systemctl start docker
    systemctl enable docker

    # 2. Instalar Docker Compose
    curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose

    # 3. Clonar y desplegar
    cd /home/ec2-user
    # Clonamos tu repo específico
    git clone https://github.com/nasar0/TFG_AWS.git 
    
    # Entramos donde está el docker-compose.yml
    cd TFG_AWS/app 

    # 4. Levantar todo el stack
    /usr/local/bin/docker-compose up -d
  EOT

  tags = { Name = "TFG-App-Completa" }
}