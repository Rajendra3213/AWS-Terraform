resource "aws_iam_role" "role" {
  name = var.role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = var.service
        }
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "policy" {
  for_each   = toset(var.policy_arns)
  role       = aws_iam_role.role.name
  policy_arn = each.value
}

resource "aws_iam_instance_profile" "profile" {
  name = "${var.role_name}-profile"
  role = aws_iam_role.role.name
}