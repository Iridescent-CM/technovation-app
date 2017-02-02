# encoding: utf-8
class FileProcessor < CarrierWave::Uploader::Base
  storage :fog

  def store_dir
    token = SecureRandom.urlsafe_base64
    "files/#{model.class.to_s.underscore}/#{mounted_as}/#{token}"
  end

  def extension_white_list
    %w(aia zip csv pdf ppt pptx)
  end
end
