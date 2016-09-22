class VerifyCachedFileValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if carrierwave_file_lost?(value.cache_dir, value.cache_name)
      record.send("remove_#{attribute}!")
      record.errors[attribute] << "We encountered an error when trying to upload your #{attribute}. Please select it again."
    end
  end

  private
  def carrierwave_file_lost?(cache_dir, cache_file_path)
    cache_file_path.present? && !file_exists?(cache_dir, cache_file_path)
  end

  def file_exists?(cache_dir, cache_file_path)
    if cache_dir[0] == '/'
      File.exists?(File.join(cache_dir, cache_file_path))
    else
      File.exists?(File.join(Rails.root, 'public', cache_dir, cache_file_path))
    end
  end
end
