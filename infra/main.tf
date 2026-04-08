data "aws_ami" "aws_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*-x86_64"]
  }
}
resource "aws_instance" "app" {
  ami                    = data.aws_ami.aws_ami.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.sg_frontend.id]
  key_name               = "aws_key_tfg"

  # Fuerza el cambio si editas el script
  user_data_replace_on_change = true

  user_data = <<-EOT
    #!/bin/bash
    # Redirigir errores a nuestro log
    exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
    
    echo "--- INICIO DEL DESPLIEGUE ---"

    # 1. Limpiar caché y forzar instalación de paquetes uno a uno
    dnf clean all
    dnf update -y
    
    echo "Instalando Git..."
    dnf install -y git
    echo "Instalando Docker..."
    dnf install -y docker
    echo "Instalando Curl..."
    dnf install -y curl

    # Verificación inmediata
    if ! command -v git &> /dev/null; then
        echo "ERROR: Git no se instaló. Intentando con yum..."
        yum install -y git
    fi

    # 2. Configurar Docker
    systemctl start docker
    systemctl enable docker
    usermod -aG docker ec2-user

    # 3. Docker Compose y Buildx (Plugins)
    mkdir -p /usr/local/lib/docker/cli-plugins
    curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 -o /usr/local/lib/docker/cli-plugins/docker-compose
    chmod +x /usr/local/lib/docker/cli-plugins/docker-compose
    ln -sf /usr/local/lib/docker/cli-plugins/docker-compose /usr/local/bin/docker-compose

    mkdir -p /usr/lib/docker/cli-plugins
    curl -fSL "https://github.com/docker/buildx/releases/download/v0.17.1/buildx-v0.17.1.linux-amd64" -o /usr/lib/docker/cli-plugins/docker-buildx 
    chmod +x /usr/lib/docker/cli-plugins/docker-buildx

    # 4. SWAP (Vital para t2.micro)
    if [ ! -f /swapfile ]; then
        echo "Creando SWAP de 2GB..."
        fallocate -l 2G /swapfile
        chmod 600 /swapfile
        mkswap /swapfile
        swapon /swapfile
    fi

    # 5. Clonar y Levantar
    cd /home/ec2-user
    echo "Clonando repositorio TFG..."
    # Usamos el usuario ec2-user
    sudo -u ec2-user git clone https://github.com/nasar0/TFG_AWS.git
    
    cd TFG_AWS/app
    
    echo "Lanzando Docker Compose..."
    export NODE_OPTIONS="--max-old-space-size=1024"
    /usr/local/bin/docker-compose up --build -d
    
    echo "--- SCRIPT FINALIZADO EXITOSAMENTE ---"
  EOT

  tags = { Name = "TFG-App-Completa" }
}
