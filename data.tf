data "aws_kms_key" "roboshop-key" {
  key_id = "alias/roboshop"
}

/* data "aws_ssm_parameter" "user" {
  name = "env.docdb.user"
}

data "aws_ssm_parameter" "pass" {
  name = "env.docdb.pass"
} */