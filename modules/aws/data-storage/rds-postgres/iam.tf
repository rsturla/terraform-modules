resource "aws_iam_role" "monitoring" {
  count = var.monitoring_interval > 0 ? 1 : 0

  name               = "${var.name}-monitoring-role"
  assume_role_policy = data.aws_iam_policy_document.monitoring_role.json

  tags = var.tags_all
}

data "aws_iam_policy_document" "monitoring_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "monitoring" {
  count = var.monitoring_interval > 0 ? 1 : 0

  role       = aws_iam_role.monitoring[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}


# IAM Policy to allow RDS to run S3 import and export
data "aws_iam_policy_document" "db_assume_role_policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["rds.amazonaws.com"]
    }
    actions = [
      "sts:AssumeRole",
    ]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values = [
        aws_db_instance.primary.arn,
      ]
    }
  }
}

# Allow RDS to run S3 import
resource "aws_iam_role" "db_s3_import" {
  count              = length(var.allowed_buckets_to_import) > 0 ? 1 : 0
  name               = "${var.name}-import"
  assume_role_policy = data.aws_iam_policy_document.db_assume_role_policy.json
}

resource "aws_iam_policy" "db_s3_import" {
  count       = length(var.allowed_buckets_to_import) > 0 ? 1 : 0
  name        = "${var.name}-import"
  description = "S3 bucket execution policy for the RDS DB to run s3 import"

  policy = data.aws_iam_policy_document.db_s3_import.json
}

data "aws_iam_policy_document" "db_s3_import" {
  statement {
    sid = "S3ReadRDSDatabase"
    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]
    effect    = "Allow"
    resources = concat(var.allowed_buckets_to_import, formatlist("%s/*", var.allowed_buckets_to_import))
  }
}

resource "aws_iam_role_policy_attachment" "db_s3_import_db" {
  count      = length(var.allowed_buckets_to_import) > 0 ? 1 : 0
  role       = aws_iam_role.db_s3_import[count.index].name
  policy_arn = aws_iam_policy.db_s3_import[count.index].arn
}

# Allow RDS to run S3 export
resource "aws_iam_role" "db_s3_export" {
  count              = length(var.allowed_buckets_to_export) > 0 ? 1 : 0
  name               = "${var.name}-export"
  assume_role_policy = data.aws_iam_policy_document.db_assume_role_policy.json
}

resource "aws_iam_policy" "db_s3_export" {
  count       = length(var.allowed_buckets_to_export) > 0 ? 1 : 0
  name        = "${var.name}-export"
  description = "S3 bucket execution policy for the RDS DB to run s3 export"

  policy = data.aws_iam_policy_document.db_s3_export.json
}

data "aws_iam_policy_document" "db_s3_export" {
  statement {
    sid = "S3WriteRDSDatabase"
    actions = [
      "s3:PutObject",
      "s3:AbortMultipartUpload",
    ]
    effect    = "Allow"
    resources = concat(var.allowed_buckets_to_export, formatlist("%s/*", var.allowed_buckets_to_export))
  }
}

resource "aws_iam_role_policy_attachment" "db_s3_export_db" {
  count      = length(var.allowed_buckets_to_export) > 0 ? 1 : 0
  role       = aws_iam_role.db_s3_export[count.index].name
  policy_arn = aws_iam_policy.db_s3_export[count.index].arn
}
