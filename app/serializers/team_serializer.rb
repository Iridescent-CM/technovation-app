class TeamSerializer
  include FastJsonapi::ObjectSerializer
  set_key_transform :camel_lower

  set_id :random_id

  attributes :id, :mentor_ids, :city, :latitude, :longitude, :name,
    :pending_mentor_invite_ids, :pending_mentor_join_request_ids

  attribute(:state) do |team|
    if country = Carmen::Country.coded(team.country)
      country.subregions.coded((team.state_province || "").sub(".", ""))
    end
  end

  attribute(:state_code) do |team|
    team.state_province
  end

  attribute(:country_code) do |team|
    team.country
  end

  attribute(:country) do |team|
    Carmen::Country.coded(team.country).try(:name)
  end
end
