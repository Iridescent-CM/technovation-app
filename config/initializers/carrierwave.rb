fog_credentials = {
  provider: "AWS",
  aws_access_key_id: ENV.fetch("AWS_ACCESS_KEY_ID"),
  aws_secret_access_key: ENV.fetch("AWS_SECRET_ACCESS_KEY"),
  region: "us-east-1",
  host: "s3.amazonaws.com",
  endpoint: "https://s3.amazonaws.com"
}

unless Rails.env.test?
  Fog::Storage.new(fog_credentials).sync_clock
end

CarrierWave.configure do |config|
  config.fog_provider = "fog/aws"
  config.fog_credentials = fog_credentials
  config.fog_directory = ENV.fetch("AWS_BUCKET_NAME")
  config.fog_public = true
  # content at a particular S3 url can change, so don't cache and rely on etags
  config.fog_attributes = {cache_control: "max-age=0"}
  config.max_file_size = 500.megabytes
end
