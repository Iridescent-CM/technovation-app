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

  column :name, header: "Name", mandatory: true

  column :actions, mandatory: true, html: true do |club|
    link_to("View",
      admin_club_path(club),
      class: "button small gray",
      data: {turbolinks: false})
  end

  column_names_filter(
    header: "More columns",
    filter_group: "more-columns",
    multiple: true
  )
end
