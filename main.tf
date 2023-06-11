resource "aws_docdb_cluster" "docdb" {
  cluster_identifier      = "${var.env}-Roboshop-cluster"
  engine                  = var.engine
  engine_version = var.engine_version
  master_username         = data.aws_ssm_parameter.user.name
  master_password         = data.aws_ssm_parameter.pass.name
  backup_retention_period = var.backup_retention_period
  preferred_backup_window = var.preferred_backup_window
  skip_final_snapshot     = var.skip_final_snapshot
  vpc_security_group_ids = [aws_security_group.docdb-sg.id]
  kms_key_id = data.aws_kms_key.roboshop-key.id
  storage_encrypted = true
  db_subnet_group_name = aws_docdb_subnet_group.docdb-subnet.name
  

}

resource "aws_docdb_cluster_instance" "cluster_instances" {
  count              = var.no_of_instances
  identifier         = "${var.env}-docdb-cluster-roboshop-${count.index}"
  cluster_identifier = aws_docdb_cluster.docdb.id
  instance_class     = var.instance_class
}

resource "aws_security_group" "docdb-sg" {
  name        = "${var.env}-roboshop-docdb-SG"
  description = "Security groups for DocDB"
  vpc_id      = var.vpc_id

  ingress {
    description      = "TLS from VPC"
    from_port        = 27017
    to_port          = 27017
    protocol         = "tcp"
    cidr_blocks      = var.allow_subnets

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.env}-roboshop-docdb-SG"
  }
}

resource "aws_docdb_subnet_group" "docdb-subnet" {
  name       = "${var.env}-DocDB subnet"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.env} docdb subnet group"
  }
}