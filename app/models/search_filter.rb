class SearchFilter < Struct.new(:filter_options)
  def fetch(key, &block)
    filter_options.fetch(key, &block)
  end

  def expertise_ids
    from_search_filter(:expertise_ids)
  end

  def gender_identities
    from_search_filter(:gender_identities)
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

  def mentor_account_id
    filter_options.fetch(:mentor_account_id) { nil }
  end

  def scope
    filter_options.fetch(:scope) { nil }
  end

  def country
    filter_options.fetch(:country) { "" }
  end

  def location
    filter_options.fetch(:location) { "" }
  end

  def needs_team
    filter_options.fetch(:needs_team) { "0" } == "1"
  end

  def on_team
    filter_options.fetch(:needs_team) { "1" } == "0"
  end

  def virtual_only
    filter_options.fetch(:virtual_only) { false } == "1"
  end

  def text
    filter_options.fetch(:text) { "" }
  end

  def division_enums
    filter_options.fetch(:division_enums) { [] }.reject(&:blank?).map(&:to_i)
  end

  def badge_css(expertise)
    if expertise_ids.include?(expertise.id)
      "success"
    else
      "notice"
    end
  end

  private
  def from_search_filter(key)
    filter_options.fetch(:search_filter) {
      {}
    }.fetch(key) {
      []
    }.reject(&:blank?).map(&:to_i)
  end
end
