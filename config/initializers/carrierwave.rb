CarrierWave.configure do |config|
  config.fog_credentials = {
    provider: "AWS",
    aws_access_key_id: ENV.fetch("AWS_ACCESS_KEY_ID"),
    aws_secret_access_key: ENV.fetch("AWS_SECRET_ACCESS_KEY"),
    region: "us-east-1",
    host: "s3.amazonaws.com",
    endpoint: "https://s3.amazonaws.com"
  }

  config.fog_directory = ENV.fetch("AWS_BUCKET_NAME")
  config.fog_public = true
  config.fog_attributes = {cache_control: "max-age=0"}

  config.enable_processing = false
  config.max_file_size = 500.megabytes
end
