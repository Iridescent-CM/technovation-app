class SearchFilter < Struct.new(:filter_options)
  def fetch(key, &block)
    filter_options.fetch(key, &block)
  end

  def expertise_ids
    filter_options.fetch(:expertise_ids) { [] }.reject(&:blank?).map(&:to_i)
  end

  def nearby
    filter_options.fetch(:nearby) { nil }
  end

  def spot_available
    filter_options.fetch(:spot_available) { false }
  end

  def has_mentor
    filter_options.fetch(:has_mentor) { :any }
  end

  def page
    filter_options.fetch(:page) { 1 }
  end

  def user
    filter_options.fetch(:user) { NoUser.new }
  end

  def needs_team
    filter_options.fetch(:needs_team) { false } == "1"
  end

  def virtual_only
    filter_options.fetch(:virtual_only) { false } == "1"
  end

  def text
    filter_options.fetch(:text) { "" }
  end

  def page
    filter_options.fetch(:page) { 0 }
  end

  def per_page
    filter_options.fetch(:per_page) { 15 }
  end

  def badge_css(expertise)
    if expertise_ids.include?(expertise.id)
      "success"
    else
      "notice"
    end
  end

  class NoUser; end
end
