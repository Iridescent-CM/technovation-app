class FileUploader < CarrierWave::Uploader::Base
  include CarrierWaveDirect::Uploader

  include ActiveModel::Conversion
  extend ActiveModel::Naming

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w[aia zip csv ppt pdf pptx]
  end

  # Override the directory where uploaded files will be stored.
  # CarrierWaveDirect::Uploader puts raw uploaded files in this directory on S3 as a first step
  def store_dir
    "direct_uploads"
  end
end
