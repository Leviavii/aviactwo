output "api_gateway_id" {
  value = aws_api_gateway_rest_api.api_011.id
}

output "event_bus_arn" {
  value = aws_cloudwatch_event_bus.ms_033.arn
}
