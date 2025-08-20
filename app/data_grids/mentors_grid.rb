class MentorsGrid
  include Datagrid

  attr_accessor :admin

  self.batch_size = 10

  scope do
    Account.includes(
      :judge_profile,
      :chapter_ambassador_profile,
      mentor_profile: :mentor_profile_mentor_types
    ).where.not(mentor_profiles: {id: nil}).order(id: :desc)
  end

  column :id, header: "Participant ID", if: ->(g) { g.admin }
  column :first_name, mandatory: true
  column :last_name, mandatory: true
  column :email, mandatory: true

  column :phone_number do |account|
    account.phone_number.presence || "-"
  end

  column :judge, header: "Judge?" do
    judge_profile.present? ? "yes" : "no"
  end

  column :chapter_ambassador, header: "Chapter Ambassador?" do
    chapter_ambassador_profile.present? ? "yes" : "no"
  end

  column :get_school_company_name, header: "Company Name", order: "mentor_profiles.company_name"

  column :job_title do
    mentor_profile.job_title.presence || "-"
  end

  column :mentor_types do
    if mentor_profile.mentor_profile_mentor_types.any?
      mentor_profile.mentor_profile_mentor_types.joins(:mentor_type).pluck(:name).join(", ")
    else
      "-"
    end
  end

  column :mentor_expertises do
    mentor_profile.expertise_names.join(",").presence || "-"
  end

  column :actions, mandatory: true, html: true do |account|
    link_to(
      "view",
      send(:"#{current_scope}_participant_path", account),
      data: {turbo: false}
    )
  end

  filter :onboarded_mentors,
    :enum,
    select: [
      ["Yes, fully onboarded", "onboarded"],
      ["No, still onboarding", "onboarding"]
    ],
    filter_group: "common" do |value, scope, grid|
    scope.send(:"#{value}_mentors")
  end

  filter :team_matching,
    :enum,
    header: "Team Matching",
    select: [
      ["Matched with a team", "matched"],
      ["Unmatched", "unmatched"],
      ["Mentors who have not answered invites from teams", "mentors_pending_invites"],
      ["Mentors with open join requests to teams", "mentors_pending_requests"]
    ],
    filter_group: "common" do |value, scope|
    scope.send(value)
  end

  filter :has_judge_profile,
    :enum,
    select: [
      ["Yes, is also a judge", "yes"],
      ["No", "no"]
    ],
    filter_group: "common" do |value, scope, grid|
    is_is_not = (value === "yes") ? "IS NOT" : "IS"

    scope.left_outer_joins(:judge_profile).where(
      "judge_profiles.id #{is_is_not} NULL"
    )
  end

  filter :has_chapter_ambassador_profile,
    :enum,
    select: [
      ["Yes, is also a chapter ambassador", "yes"],
      ["No", "no"]
    ],
    filter_group: "common" do |value, scope, grid|
    is_is_not = (value === "yes") ? "IS NOT" : "IS"

    scope.left_outer_joins(:chapter_ambassador_profile).where(
      "chapter_ambassador_profiles.id #{is_is_not} NULL"
    )
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
      .left_outer_joins(:mentor_profile)
  end

  filter :school_company_name,
    header: "Company Name",
    filter_group: "common" do |value, scope|
    scope
      .includes(:mentor_profile)
      .references(:mentor_profiles)
      .where(
        "mentor_profiles.school_company_name ILIKE ? ", +
      "%#{value}%"
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

  column_names_filter(
    header: "More columns",
    filter_group: "more-columns",
    multiple: true
  )
end
