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

  filter(:visible_on_map, :xboolean)

  column :legal_agreement_status do
    if legal_document.present?
      legal_document.signed? ? "Signed" : "Not signed"
    else
      "Not sent"
    end
  end

  column :legal_agreement_valid_for do
    legal_contact&.seasons_legal_agreement_is_valid_for&.join(", ")
  end

  column :visible_on_map, header: "Visible on map"

  column :actions, mandatory: true, html: true do |chapter|
    render "admin/chapters/actions", chapter: chapter
  end

  column_names_filter(
    header: "More columns",
    filter_group: "more-columns",
    multiple: true
  )
end
