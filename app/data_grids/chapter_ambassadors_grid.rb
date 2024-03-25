class ChapterAmbassadorsGrid
  include Datagrid

  self.batch_size = 10

  scope do
    Account.includes(:chapter_ambassador_profile).where.not(chapter_ambassador_profiles: {id: nil}).order(id: :desc)
  end

  column :name, header: "Chapters (Program Name)", mandatory: true, html: true do |account|
    if account.chapter_ambassador_profile.chapter.present?
      link_to(
        account.chapter_ambassador_profile.chapter.name.presence || "-",
        admin_chapter_path(account.chapter_ambassador_profile.chapter)
      )
    else
      "No chapter"
    end
  end

  column :chapter, header: "Chapter(Program Name)", html: false do |account|
    if account.chapter_ambassador_profile.chapter.present?
      account.chapter_ambassador_profile.chapter.name.presence || "-"
    else
      "No chapter"
    end
  end

  column :organization_name, header: "Organization Name", mandatory: true do |account|
    if account.chapter_ambassador_profile.chapter.present?
      account.chapter_ambassador_profile.chapter.organization_name.presence || "-"
    else
      "No chapter"
    end
  end

  column :organization_name, header: "Organization Name", html: false do |account|
    if account.chapter_ambassador_profile.chapter.present?
      account.chapter_ambassador_profile.chapter.organization_name.presence || "-"
    else
      "No chapter"
    end
  end

  column :first_name, mandatory: true
  column :last_name, mandatory: true
  column :email, mandatory: true
  column :id, header: "Participant ID"

  column :gender, header: "Gender Identity" do
    gender.presence || "-"
  end

  column :phone_number do
    chapter_ambassador_profile.phone_number.presence || "-"
  end

  column :organization_status do
    chapter_ambassador_profile.organization_status.presence || "-"
  end

  column :mentor, header: "Mentor?" do
    mentor_profile.present? ? "yes" : "no"
  end

  column :city

  column :state_province, header: "State" do
    FriendlySubregion.call(self, prefix: false)
  end

  column :country do
    FriendlyCountry.new(self).country_name
  end

  column :actions, mandatory: true, html: true do |account|
    link_to(
      "view",
      send("#{current_scope}_participant_path", account),
      data: {turbolinks: false}
    )
  end

  filter :has_mentor_profile,
    :enum,
    select: [
      ["Yes, is also a mentor", "yes"],
      ["No", "no"]
    ],
    filter_group: "common" do |value, scope, grid|
      is_is_not = (value === "yes") ? "IS NOT" : "IS"

      scope.left_outer_joins(:mentor_profile).where(
        "mentor_profiles.id #{is_is_not} NULL"
      )
  end

  filter :assigned_to_chapter,
    :enum,
    select: [
      ["Yes", "yes"],
      ["No", "no"]
    ],
    filter_group: "common" do |value, scope, grid|
      is_is_not = (value === "yes") ? "IS NOT" : "IS"

      scope.left_outer_joins(:chapter_ambassador_profile).where(
        "chapter_ambassador_profiles.chapter_id #{is_is_not} NULL"
      )
  end

  filter :season,
    :enum,
    select: (2015..Season.current.year).to_a.reverse,
    html: {
      class: "and-or-field"
    },
    multiple: true do |value, scope, grid|
    scope.by_season(value)
  end


  filter :name_email,
    header: "Name or Email",
    filter_group: "common" do |value, scope, grid|
      names = value.strip.downcase.split(" ").map { |n|
        I18n.transliterate(n).gsub("'", "''")
      }
      scope.fuzzy_search({
        first_name: names.first,
        last_name: names.last || names.first,
        email: names.first
      }, false)
        .left_outer_joins(:chapter_ambassador_profile)
    end

  filter :program_name do |value, scope|
    scope
      .left_outer_joins(:chapter_ambassador_profile)
      .left_outer_joins(chapter_ambassador_profile: :chapter)
      .where("chapters.name ilike ?", "#{value}%")
  end

  filter :organization_name do |value, scope|
    scope
      .left_outer_joins(:chapter_ambassador_profile)
      .left_outer_joins(chapter_ambassador_profile: :chapter)
      .where("chapters.organization_name ilike ?", "#{value}%")
  end

  column_names_filter(
    header: "More columns",
    filter_group: "more-columns",
    multiple: true
  )
end
