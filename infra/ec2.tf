resource "aws_instance" "gitlab" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.gitlab_instance_type
  subnet_id                   = data.aws_subnets.public.ids[0]
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.gitlab.name
  key_name                    = data.aws_key_pair.example.key_name

  vpc_security_group_ids = [aws_security_group.gitlab.id]
  user_data              = file("./templates/gitlab/gitlab-setup.sh")


  tags = {
    Name = "Gitlab"
    AutoStop = "true"
  }
}

resource "aws_instance" "staging_server" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.forum_instance_type
  subnet_id                   = data.aws_subnets.public.ids[0]
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.forum.name
  key_name                    = data.aws_key_pair.example.key_name

  vpc_security_group_ids = [aws_security_group.forum.id]
  user_data              = file("./templates/forum/forum-setup.sh")


  tags = {
    Name = "staging_server"
    AutoStop = "true"
  }
}
