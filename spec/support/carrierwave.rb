Fog.mock!
Fog.credentials = { # match what carrierwave will use
  aws_access_key_id: ENV.fetch("AWS_ACCESS_KEY_ID"),
  aws_secret_access_key: ENV.fetch("AWS_SECRET_ACCESS_KEY"),
  region: 'us-east-1',
}
# make fog think the bucket exists
connection = Fog::Storage.new(:provider => 'AWS')
connection.directories.create(:key => ENV.fetch("AWS_BUCKET_NAME"))

CarrierWave.configure do |config|
  config.enable_processing = false
end