output "lambda" {
    value                   = {
        arn                 = aws_lambda_function.this.arn
        invoke_arn          = aws_lambda_function.this.invoke_arn 
        function_name       = local.function_name
    }
}