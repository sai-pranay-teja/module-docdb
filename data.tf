data "aws_kms_key" "roboshop-key" {
  key_id = "alias/roboshop"
}

data "aws_ssm_parameter" "user" {
  name = "dev.docdb.user"
}

data "aws_ssm_parameter" "pass" {
  name = "dev.docdb.pass"
}