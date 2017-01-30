fog_credentials = {
  provider: 'AWS',
  aws_access_key_id: ENV.fetch("AWS_ACCESS_KEY_ID"),
  aws_secret_access_key: ENV.fetch("AWS_SECRET_ACCESS_KEY"),
  region: 'us-east-1',
  host: 's3.amazonaws.com',
  endpoint: 'https://s3.amazonaws.com',
}

unless Rails.env.test?
  Fog::Storage.new(fog_credentials).sync_clock
end

CarrierWave.configure do |config|
  config.fog_credentials = fog_credentials
  config.fog_directory = ENV.fetch("AWS_BUCKET_NAME")
  config.fog_public = true
  config.fog_attributes = { 'Cache-Control'=>'max-age=315576000' }
  config.max_file_size = 500.megabytes
end
