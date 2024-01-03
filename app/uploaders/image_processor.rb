class ImageProcessor < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  process :fix_exif_rotation

  # Choose what kind of storage to use for this uploader:
  storage :fog

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  process resize_to_fill: [233, 233]

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  #
  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
    "https://placekitten.com/g/#{default_url_endpoint_size}"
  end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  version :thumb do
    process resize_to_fill: [80, 80]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w[bmp jpg jpeg gif png]
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

  private

  def default_url_endpoint_size
    case version_name
    when :thumb
      "80/80"
    else
      "233/233"
    end
  end

  def fix_exif_rotation
    manipulate! do |img|
      img.auto_orient
      img = yield(img) if block_given?
      img
    end
  end
end
