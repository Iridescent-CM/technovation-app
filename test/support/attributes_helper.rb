module AttributesHelper
  def auth_attributes(attrs = {})
    pwd = attrs.fetch(:password) { "auth@example.com" }
    { email: pwd,
      password: pwd,
      password_confirmation: pwd }.merge(attrs)
  end

  def judge_attributes(attrs = {})
    if ScoreCategory.count.zero?
      ScoreCategory.create!(score_category_attributes)
    end

    auth_attributes.merge(judge_profile_attributes: {
      expertise_ids: ScoreCategory.pluck(:id)
    }).merge(attrs)
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
