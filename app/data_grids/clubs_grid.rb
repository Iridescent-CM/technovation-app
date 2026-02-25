class ClubsGrid
  include Datagrid

  self.batch_size = 10

  scope do
    Club.order(id: :desc)
  end

  filter :name do |value|
    sanitized = sanitize_sql_like(value)
    processed_value = I18n.transliterate(sanitized.strip.downcase).gsub(/['\s]+/, "%")

    where("lower(unaccent(name)) ILIKE ?", "%#{processed_value}%")
  end

  filter :season,
    :enum,
    select: (2025..Season.current.year).to_a.reverse,
    filter_group: "more-specific",
    html: {
      class: "and-or-field"
    },
    multiple: false do |value|
    by_season(value)
  end

  filter(:visible_on_map, :xboolean)

  filter(:onboarded,
    :enum,
    select: [
      ["Yes, fully onboarded", true],
      ["No, still onboarding", false]
    ]) do |value|
    where(onboarded: value)
  end

  column :name, header: "Name", mandatory: true

  column :city

  column :state_province, header: "State" do
    FriendlySubregion.call(self, prefix: false)
  end

  column :country do
    FriendlyCountry.new(self).country_name
  end

  column :seasons do
    seasons.to_sentence
  end

  column :primary_contact_name, preload: [:primary_contact] do
    primary_contact&.full_name.presence || "-"
  end

  column :primary_contact_email_address, preload: [:primary_contact] do
    primary_contact&.email.presence || "-"
  end

  column :visible_on_map, header: "Visible on map"

  column :onboarded do
    onboarded? ? "yes" : "no"
  end

  column :actions, mandatory: true, html: true do |club|
    link_to("View",
      admin_club_path(club),
      class: "button small gray",
      data: {turbo: false})
  end

  filter :country,
    :enum,
    header: "Country",
    select: ->(g) {
      CountryStateSelect.countries_collection
    },
    filter_group: "more-specific",
    multiple: true,
    data: {
      placeholder: "Select or start typing..."
    } do |values|
    clauses = values.flatten.map { |v| "clubs.country = '#{v}'" }
    where(clauses.join(" OR "))
  end

  column_names_filter(
    header: "More columns",
    filter_group: "more-columns",
    multiple: true
  )
end
