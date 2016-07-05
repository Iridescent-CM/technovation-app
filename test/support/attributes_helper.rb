module AttributesHelper
  def account_attributes(attrs = {})
    pwd = attrs.fetch(:password) { "auth@example.com" }
    {
      email: pwd,
      password: pwd,
      password_confirmation: pwd,
      first_name: "Basic",
      last_name: "McGee",
      date_of_birth: Date.today - 33.years,
      city: "Chicago",
      state_province: "IL",
      country: "US",
    }.deep_merge(attrs)
  end

  def student_attributes(attrs = {})
    account_attributes({
      student_profile_attributes: {
        parent_guardian_email: "parent@parent.com",
        parent_guardian_name: "Parenty Parent",
        school_name: "John Hughes High",
      },
    }).deep_merge(attrs)
  end

  def judge_attributes(attrs = {})
    if ScoreCategory.count.zero?
      ScoreCategory.create!(score_category_attributes)
    end

    account_attributes({
      judge_profile_attributes: {
        scoring_expertise_ids: ScoreCategory.pluck(:id),
        company_name: "ACME, Inc.",
        job_title: "Engineer in Coyote Aerodynamics",
      }
    }).deep_merge(attrs)
  end

  def mentor_attributes(attrs = {})
    if Expertise.count.zero?
      Expertise.create!(expertise_attributes)
    end

    account_attributes({
      mentor_profile_attributes: {
        expertise_ids: Expertise.pluck(:id),
        school_company_name: "Chicago Public Schools",
        job_title: "Administrator",
      },
    }).deep_merge(attrs)
  end

  def score_category_attributes(attrs = {})
    { name: "Ideation" }.merge(attrs)
  end

  def expertise_attributes(attrs = {})
    { name: "Science" }.merge(attrs)
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
