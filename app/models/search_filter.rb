class SearchFilter < Struct.new(:filter_options)
  def fetch(key, &block)
    filter_options.fetch(key, &block)
  end

  def expertise_ids
    filter_options.fetch(:expertise_ids) { [] }.reject(&:blank?).map(&:to_i)
  end

  def nearby
    filter_options.fetch(:nearby) { "" }
  end

  def badge_css(expertise)
    if expertise_ids.include?(expertise.id)
      "success"
    else
      "notice"
    end
  end
end
