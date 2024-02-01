# #CW for webtier
# resource "aws_cloudwatch_metric_alarm" "web_alarm" {
#   alarm_name          = "example-alarm"
#   comparison_operator = "GreaterThanOrEqualToThreshold"
#   evaluation_periods  = 2
#   metric_name         = "CPUUtilization"
#   namespace           = "AWS/EC2"
#   period              = 300
#   statistic           = "Average"
#   threshold           = 80

#   dimensions = {
#     InstanceId = aws_launch_template.template-web.id
#   }

#   alarm_description = "This is an example alarm."

#   actions_enabled = true
#   alarm_actions   = [aws_sns_topic.web_sns.arn]
# }
# #SNS for webtier
# resource "aws_sns_topic" "web_sns" {
#   name = "web_sns"
# }
# #########################################################
# resource "aws_cloudwatch_metric_alarm" "app_alarm" {
#   alarm_name          = "example-alarm"
#   comparison_operator = "GreaterThanOrEqualToThreshold"
#   evaluation_periods  = 2
#   metric_name         = "CPUUtilization"
#   namespace           = "AWS/EC2"
#   period              = 300
#   statistic           = "Average"
#   threshold           = 80

#   dimensions = {
#     InstanceId = aws_launch_template.template-app.id
#   }
#   alarm_description = "This is an web instance CPU utilisation alarm."
#   actions_enabled   = true
#   alarm_actions     = [aws_sns_topic.app_sns.arn]
# }
# #SNS for webtier
# resource "aws_sns_topic" "app_sns" {
#   name = "app_sns"
# }
# #########################################################
# # Create an SNS subscription for SMS - web
# resource "aws_sns_topic_subscription" "sms_subscription-web" {
#   topic_arn = aws_sns_topic.web_sns.arn
#   protocol  = "sms"
#   endpoint  = "+15135259935" # Replace with the phone number to receive SMS
# }
# # Create an SNS subscription for email - web
# resource "aws_sns_topic_subscription" "email_subscription-web" {
#   topic_arn = aws_sns_topic.web_sns.arn
#   protocol  = "email"
#   endpoint  = "shuhx7@gmail.com" # Replace with the email address to receive emails
# }

# # Create an SNS subscription for SMS - app
# resource "aws_sns_topic_subscription" "sms_subscription-app" {
#   topic_arn = aws_sns_topic.app_sns.arn
#   protocol  = "sms"
#   endpoint  = "+15135259935" # Replace with the phone number to receive SMS
# }
# # Create an SNS subscription for email - app
# resource "aws_sns_topic_subscription" "email_subscription-app" {
#   topic_arn = aws_sns_topic.app_sns.arn
#   protocol  = "email"
#   endpoint  = "shuhx7@gmail.com" # Replace with the email address to receive emails
# }