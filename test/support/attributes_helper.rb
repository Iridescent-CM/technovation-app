module AttributesHelper
  def auth_attributes(attrs = {})
    pwd = attrs.fetch(:password) { "auth@example.com" }
    { email: pwd,
      password: pwd,
      password_confirmation: pwd }.merge(attrs)
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
end
