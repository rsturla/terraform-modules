resource "aws_iam_instance_profile" "instance" {
  name = "${var.name_prefix}-nat-instance-profile"
  role = aws_iam_role.instance.name
}

data "aws_iam_policy_document" "assume_role_instance" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "instance" {
  name               = "${var.name_prefix}-nat-instance-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_instance.json
}

resource "aws_iam_role_policy_attachment" "instance_ssm_managed_instance" {
  role       = aws_iam_role.instance.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
