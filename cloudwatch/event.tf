resource "aws_cloudwatch_event_rule" "ecr_push" {
  name        = "capture-ecr-push"
  description = "Capture ECR Push image event"

  event_pattern = <<EOF
{
  "source": ["aws.ecr"],
  "detail-type": ["ECR Image Action"],
  "detail": {
    "action-type": ["PUSH"],
    "result": ["SUCCESS"],
    "repository-name": ["demo-ecr"],
    "image-tag": ["latest"]
  }
}
EOF
}

resource "aws_cloudwatch_event_target" "sns" {
  rule      = aws_cloudwatch_event_rule.console.name
  target_id = "SendToSNS"
  arn       = aws_sns_topic.aws_logins.arn
}
