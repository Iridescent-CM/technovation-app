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

  filter :legal_agreement_status,
    :enum,
    select: ["Signed", "Not signed", "Not sent"] do |value|
      case value
      when "Signed"
        signed_legal_agreements
      when "Not signed"
        not_signed_legal_agreements
      when "Not sent"
        not_sent_legal_agreements
      end
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

  column :start_date, header: "Program Start Date" do
    chapter_program_information&.start_date&.strftime("%m-%d-%Y")
  end

  column :meeting_times do
    meeting_times = chapter_program_information&.meeting_times
    if meeting_times&.any?
      meeting_times.pluck(:time).join(", ")
    else
      "-"
    end
  end

  column :program_length do
    chapter_program_information&.program_length&.length.presence || "-"
  end

  column :meeting_facilitators do
    meeting_facilitators = chapter_program_information&.meeting_facilitators
    if meeting_facilitators&.any?
      meeting_facilitators.pluck(:name).join(", ")
    else
      "-"
    end
  end

  column :participant_count_estimate, header: "Estimated Participation" do
    chapter_program_information&.participant_count_estimate&.range.presence || "-"
  end

  column :low_income_estimate, header: "Percent Underresourced" do
    chapter_program_information&.low_income_estimate&.percentage.presence || "-"
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
