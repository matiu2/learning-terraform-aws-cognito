resource "aws_cognito_identity_pool" "id_pool" {
  identity_pool_name = "PetIDFIDPool"
  supported_login_providers = {
    "accounts.google.com" = var.google_client_id
  }

}

resource "aws_cognito_identity_pool_roles_attachment" "main" {
  identity_pool_id = aws_cognito_identity_pool.id_pool.id
  roles = {
      authenticated = aws_iam_role.authed_role.arn
      unauthenticated = aws_iam_role.unauthed_role.arn
   }
}

// Permissions for people that are authenticated against google

resource "aws_iam_role" "authed_role" {
  name = "Cognito_PetIDFIDPoolAuth_Role"

  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Action = "sts:AssumeRoleWithWebIdentity"
          Effect = "Allow"
          Condition = {
            "ForAnyValue:StringLike" = {
              "cognito-identity.amazonaws.com:amr" = "authenticated"
            }
            StringEquals = {
              "cognito-identity.amazonaws.com:aud" = aws_cognito_identity_pool.id_pool.id
            }
          }
          Principal = {
            Federated = "cognito-identity.amazonaws.com"
          }
        },
      ]
  })

}

resource "aws_iam_role_policy" "authed_policy1" {
    name = "authed_policy"
    role = aws_iam_role.authed_role.id

    policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
        {
            Effect = "Allow",
            Action = [
            "mobileanalytics:PutEvents",
            "cognito-sync:*",
            "cognito-identity:*"
            ],
            Resource : ["*"]
        }
        ]
    })
}

// A user that is authenticated via cognito, can read from private_bucket
resource "aws_iam_role_policy" "authed_read_private_bucket" {
    name = "authed_read_private_bucket"
    role = aws_iam_role.authed_role.id

    policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
        {
            Sid       = "AuthedCanReadBucket"
            Effect    = "Allow"
            Action    = ["s3:ListBucket", "s3:GetObject"]
            Resource = [
            aws_s3_bucket.private_bucket.arn,
            "${aws_s3_bucket.private_bucket.arn}/*",
            ]
        }
        ]
    })
}

// Permissions for users that are not authenticated against google

resource "aws_iam_role" "unauthed_role" {
  name = "Cognito_PetIDFIDPoolUnauth_Role"

  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Action = "sts:AssumeRoleWithWebIdentity"
          Effect = "Allow"
          Condition = {
            "ForAnyValue:StringLike" = {
              "cognito-identity.amazonaws.com:amr" = "unauthenticated"
            }
            StringEquals = {
              "cognito-identity.amazonaws.com:aud" = aws_cognito_identity_pool.id_pool.id
            }
          }
          Principal = {
            Federated = "cognito-identity.amazonaws.com"
          }
        },
      ]
  })
}

resource "aws_iam_role_policy" "unauthed_policy" {
    name = "unauthed_policy"
    role = aws_iam_role.unauthed_role.id

    policy = jsonencode({
      Version = "2012-10-17",
      Statement = [
        {
          Effect = "Allow",
          Action = [
            "mobileanalytics:PutEvents",
            "cognito-sync:*",
          ],
          Resource : ["*"]
        }
      ]
    })
}
