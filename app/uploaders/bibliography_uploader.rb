class BibliographyUploader < CarrierWave::Uploader::Base
  storage :fog

  def store_dir
    "files/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_white_list
    %w[pdf]
  end
end
