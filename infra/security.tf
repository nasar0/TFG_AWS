#Security Group para Frontend

resource "aws_security_group" "sg_frontend" {
  name   = "sg_tfg_frontend"
  vpc_id = aws_vpc.tfg_vpc.id

  # Puerto 80: El mundo entero puede ver tu React
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  # Puerto 22: Para que tú puedas entrar por SSH desde tu PC
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#Security Group para Backend

resource "aws_security_group" "sg_backend" {
  name   = "sg_tfg_backend"
  vpc_id = aws_vpc.tfg_vpc.id

  # Puerto 80: SOLO permite la entrada si viene del SG del Frontend
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    # MAGIA: En lugar de IP, usamos el ID del grupo anterior
    security_groups = [aws_security_group.sg_frontend.id] 
  }

  # SSH también limitado (opcional, pero más seguro)
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.sg_frontend.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}