class PaperParentalConsentUploader < CarrierWave::Uploader::Base
  storage :fog

  def store_dir
    "paper_consent_uploads/#{model.class.to_s.underscore}/#{model.id}"
  end

  def extension_whitelist
    %w[jpg jpeg gif png pdf]
  end
end
