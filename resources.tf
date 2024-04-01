resource "aws_iam_role" "lambda_role" {
    name = "lambda_role"

    assume_role_policy = jsonencode({
        Statement = [
            {
                Effect = "Allow",
                Principal = {
                    Service = "lambda.amazonaws.com"
                },
                Action = "sts:AssumeRole"
            }
        ]
    })
  
}

resource "aws_lambda_function" "hello_world_lambda" {
    filename = "lambda_function.zip"
    function_name = "hello_world_lambda"
    role = aws_iam_role.lambda_role.arn
    handler = "lambda_function.lambda_handler"
    runtime = "python3.8"  
}

data "archive_file" "lambda_zip" {
    type ="zip"
    source_file ="lambda_function.py"
    output_path = "lambda_function.zip"
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
    role = aws_iam_role.lambda_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  
}