resource "aws_security_group" "insecure_sg" {
  name        = "allow-ssh-world"
  description = "Security group exposing SSH to the internet"
  vpc_id      = "vpc-12345678"

  ingress {
    description = "Allow global port 8080 access"
    from_port   = 8080
    to_port     = 8080
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