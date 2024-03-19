class ChaptersGrid
  include Datagrid

  self.batch_size = 10

  scope do
    Chapter.order(id: :desc)
  end

  column :name, header: "Chapters (Program Name)", mandatory: true, html: true do |chapter|
    link_to(
      chapter.name.presence || "-",
      admin_chapter_path(chapter)
    )
  end

  column :name, header: "Chapters (Program Name)", html: false do |chapter|
    chapter.name.presence || "-"
  end

  column :organization_name, header: "Organization", mandatory: true

  filter :program_name do |value|
    where("name ilike ?",
      "#{value}%")
  end

  filter :organization_name do |value|
    where("organization_name ilike ?",
      "#{value}%")
  end

  column :actions, mandatory: true, html: true do |chapter|
    render "admin/chapters/actions", chapter: chapter
  end

  column_names_filter(
    header: "More columns",
    filter_group: "more-columns",
    multiple: true
  )
end
