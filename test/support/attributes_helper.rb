module AttributesHelper
  def auth_attributes(attrs = {})
    pwd = attrs.fetch(:password) { "auth@example.com" }
    { email: pwd,
      password: pwd,
      password_confirmation: pwd,
      basic_profile_attributes: {
        first_name: "Authy",
        last_name: "McGee",
        date_of_birth: Date.today - 33.years,
        city: "Chicago",
        region: "IL",
        country: "US",
      }, }.deep_merge(attrs)
  end

  def judge_attributes(attrs = {})
    if ScoreCategory.count.zero?
      ScoreCategory.create!(score_category_attributes)
    end

    auth_attributes({
      judge_profile_attributes: {
        expertise_ids: ScoreCategory.pluck(:id),
        company_name: "ACME, Inc.",
        job_title: "Engineer in Coyote Aerodynamics",
      }
    }).deep_merge(attrs)
  end

  def score_category_attributes(attrs = {})
    { name: "Ideation" }.merge(attrs)
  end

  def team_attributes(attrs = {})
    { name: "Team name",
      description: "Team description",
      region: Region.create!(region_attributes),
      division: Division.high_school }.merge(attrs)
  end

  def region_attributes(attrs = {})
    { name: "US/Canada" }.merge(attrs)
  end

  def submission_attributes(attrs = {})
    { code: "submission code",
      demo: "submission demo",
      pitch: "submission pitch",
      description: "submission description" }.merge(attrs)
  end
end
