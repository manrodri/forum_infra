#### Instance profiles
resource "aws_iam_instance_profile" "gitlab" {

  lifecycle {
    create_before_destroy = false
  }

  name = "${terraform.workspace}_gitlab_profile"
  role = aws_iam_role.gitlab.name
}

resource "aws_iam_instance_profile" "forum" {

  lifecycle {
    create_before_destroy = false
  }

  name = "${terraform.workspace}_forum_profile"
  role = aws_iam_role.forum.name
}

#### Instance roles

resource "aws_iam_role" "gitlab" {
  name = "${terraform.workspace}_gitlab_role"
  path = "/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
  EOF
}

resource "aws_iam_role" "forum" {
  name = "${terraform.workspace}_forum_role"
  path = "/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
  EOF
}


#### S3 policies

resource "aws_iam_role_policy" "s3" {
  name = "${terraform.workspace}-forum-cicd-server-policy"
  role = aws_iam_role.gitlab.id

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "*"
        ],
        "Effect": "Allow",
        "Resource": [
                "*"
            ]
      }
    ]
  }
  EOF
}

resource "aws_iam_role_policy_attachment" "sto-s3-role-policy-attach" {
  role       = aws_iam_role.forum.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
}

resource "aws_iam_role_policy_attachment" "sto-ssm-role-policy-attach" {
  role       = aws_iam_role.forum.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "sto-ec2-role-policy-attach" {
  role       = aws_iam_role.forum.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}




