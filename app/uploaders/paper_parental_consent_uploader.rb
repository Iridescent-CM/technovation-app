class PaperParentalConsentUploader < CarrierWave::Uploader::Base
  MAXIMUM_UPLOAD_FILE_SIZE_IN_MEGABYTES = 3

  storage :fog

  def store_dir
    "paper_consent_uploads/#{model.class.to_s.underscore}/#{model.id}"
  end

  def extension_whitelist
    %w[jpg jpeg gif png pdf]
  end

  def size_range
    0..MAXIMUM_UPLOAD_FILE_SIZE_IN_MEGABYTES.megabytes
  end
end
