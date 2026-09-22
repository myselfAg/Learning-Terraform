# Creating User
resource "aws_iam_user" "admin-user" {
  name = "sneha"
  tags = {
    Description = "Technical Lead"
  }
}

# Creating Policy
resource "aws_iam_policy" "administrator" {
  name = "Administrator"
  policy = <<EOF
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": "*",
                "Resource": "*"
            }
        ]
    }
  EOF
}

# Attaching Policy to the User
resource "aws_iam_user_policy_attachment" "sneha-admin-access" {
  user = aws_iam_user.admin-user.name
  policy_arn = aws_iam_policy.administrator.arn
}