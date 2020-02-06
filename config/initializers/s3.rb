if ENV["AWS_ACCESS_KEY_ID"]
  S3_POOL = ConnectionPool.new(size: 10, timeout: 5) {
    Fog::Storage.new(
      provider: "AWS",
      aws_access_key_id: ENV["AWS_ACCESS_KEY_ID"],
      aws_secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"],
      region: ENV["AWS_S3_REGION"] || "us-east-1",
      host: ENV["AWS_HOST"] || "s3.amazonaws.com",
      persistent: true,
    )
  }
end
