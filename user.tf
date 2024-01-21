# #########################################
resource "aws_iam_user" "users" {
  for_each = var.users
  name     = each.value.name
  tags = {
    Name = join("-", [var.prefix, each.key])
  }
}


# Groups
resource "aws_iam_group" "sysadmin_group" {
  name = "Sytem_Administrator_Group"
}
resource "aws_iam_group" "dbadmin_group" {
  name = "Database_Administrator_Group"
}
resource "aws_iam_group" "Monitoring_Group" {
  name = "Monitoring_Group"
}

######################################################
# Group Policy
data "aws_iam_policy" "sysadmin" {
  arn = "arn:aws:iam::aws:policy/job-function/SystemAdministrator"
}

data "aws_iam_policy" "monitor" {
  arn = "arn:aws:iam::aws:policy/job-function/ViewOnlyAccess"
}

data "aws_iam_policy" "db_admin" {
  arn = "arn:aws:iam::aws:policy/job-function/DatabaseAdministrator"
}

# Group Policy attachment
resource "aws_iam_group_policy_attachment" "sysadmin" {
  policy_arn = data.aws_iam_policy.sysadmin.arn
  group      = aws_iam_group.sysadmin_group.name
}

resource "aws_iam_group_policy_attachment" "monitor" {
  policy_arn = data.aws_iam_policy.monitor.arn
  group      = aws_iam_group.Monitoring_Group.name
}

resource "aws_iam_group_policy_attachment" "db_admin" {
  policy_arn = data.aws_iam_policy.db_admin.arn
  group      = aws_iam_group.dbadmin_group.name
}

############################################
# Membership
resource "aws_iam_user_group_membership" "team1" {
  for_each = toset(["sysadmin1", "sysadmin2"])
  user     = aws_iam_user.users[each.key].name
  groups = [
    "${aws_iam_group.sysadmin_group.name}"
  ]
}
resource "aws_iam_user_group_membership" "team2" {
  for_each = toset(["dbadmin1", "dbadmin2"])
  user     = aws_iam_user.users[each.key].name
  groups = [
    "${aws_iam_group.dbadmin_group.name}"
  ]
}
resource "aws_iam_user_group_membership" "team3" {
  for_each = toset(["monitor1", "monitor2", "monitor3", "monitor4"])
  user     = aws_iam_user.users[each.key].name
  groups = [
    "${aws_iam_group.Monitoring_Group.name}"
  ]
}

################################################
# Login and Password
resource "aws_iam_user_login_profile" "pass" {
  for_each = var.users
  user     = aws_iam_user.users[each.key].name
}
# Password policy (account-wide setting, and not attached to exact resource.)
resource "aws_iam_account_password_policy" "strict" {
  minimum_password_length        = 8
  require_lowercase_characters   = true
  require_numbers                = true
  require_uppercase_characters   = true
  require_symbols                = true
  allow_users_to_change_password = true
  hard_expiry                    = true
  max_password_age               = 90
  password_reuse_prevention      = 3
}


resource "aws_secretsmanager_secret" "users" {
  name                    = "users_passwords"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "users" {
    for_each = var.users
    secret_id = aws_secretsmanager_secret.users.id
    secret_string = jsonencode({
    username = aws_iam_user.users[each.key].name
    password = aws_iam_user_login_profile.pass[each.key].password
  })
}







# # # Create access keys for users
# # resource "aws_iam_access_key" "user_access_keys1" {
# #   for_each = toset(["sysadmin1", "sysadmin2"])
# #   user     = aws_iam_user.SysAdmin[each.key].name
# # }
# # resource "aws_iam_access_key" "user_access_keys2" {
# #   for_each = toset(["dbadmin1", "dbadmin2"])
# #   user     = aws_iam_user.DBAdmin[each.key].name
# # }
# # resource "aws_iam_access_key" "user_access_keys3" {
# #   for_each = toset(["monitoruser1", "monitoruser2", "monitoruser3", "monitoruser4"])
# #   user     = aws_iam_user.Monitoring[each.key].name
# # }



