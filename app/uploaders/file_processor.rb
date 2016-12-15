# encoding: utf-8
class FileProcessor < CarrierWave::Uploader::Base
  storage :fog

  def store_dir
    "files/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_white_list
    %w(aia zip csv pdf ppt pptx)
  end
end
