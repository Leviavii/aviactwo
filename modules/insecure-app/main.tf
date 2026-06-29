# Cross-repo C2C source-tracing test — APP module.
# All misconfigurations are hardcoded HERE (aviactwo). The aviac caller only
# passes name_prefix.

###############################################################################
# APIGateway-011: API Gateway stages execution (CloudWatch) logging should be on
# Misconfig: REST API stage with no method_settings -> execution logging off.
###############################################################################
resource "aws_api_gateway_rest_api" "api_011" {
  name = "${var.name_prefix}-api-011"
  tags = { Project = "wiz-c2c-crossrepo-test" }
}

resource "aws_api_gateway_resource" "api_011" {
  rest_api_id = aws_api_gateway_rest_api.api_011.id
  parent_id   = aws_api_gateway_rest_api.api_011.root_resource_id
  path_part   = "test"
}

resource "aws_api_gateway_method" "api_011" {
  rest_api_id   = aws_api_gateway_rest_api.api_011.id
  resource_id   = aws_api_gateway_resource.api_011.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "api_011" {
  rest_api_id = aws_api_gateway_rest_api.api_011.id
  resource_id = aws_api_gateway_resource.api_011.id
  http_method = aws_api_gateway_method.api_011.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_deployment" "api_011" {
  rest_api_id = aws_api_gateway_rest_api.api_011.id
  depends_on  = [aws_api_gateway_integration.api_011]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "api_011" {
  stage_name    = "prod"
  rest_api_id   = aws_api_gateway_rest_api.api_011.id
  deployment_id = aws_api_gateway_deployment.api_011.id
  # No method_settings / access logging -> execution logging disabled.
  tags = { Project = "wiz-c2c-crossrepo-test" }
}

###############################################################################
# MessagingService-033: Event Bus should not allow access to all principals
# Misconfig: resource policy with Principal "*", Allow, no condition.
###############################################################################
resource "aws_cloudwatch_event_bus" "ms_033" {
  name = "${var.name_prefix}-bus-033"
  tags = { Project = "wiz-c2c-crossrepo-test" }
}

resource "aws_cloudwatch_event_bus_policy" "ms_033" {
  event_bus_name = aws_cloudwatch_event_bus.ms_033.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid       = "AllowAllPrincipals"
      Effect    = "Allow"
      Principal = "*"
      Action    = "events:PutEvents"
      Resource  = aws_cloudwatch_event_bus.ms_033.arn
    }]
  })
}

###############################################################################
# DataWorkload-074: Glue Data Catalog metadata encryption should be enabled
# Misconfig: catalog encryption mode DISABLED (region-level setting).
###############################################################################
resource "aws_glue_data_catalog_encryption_settings" "dw_074" {
  data_catalog_encryption_settings {
    encryption_at_rest {
      catalog_encryption_mode = "DISABLED"
    }
    connection_password_encryption {
      return_connection_password_encrypted = false
    }
  }
}
