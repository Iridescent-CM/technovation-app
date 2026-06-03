class RegeocodeTeamPrimaryLoations < ActiveRecord::Migration[4.2]
  def up
    Team.current.where("city IS NULL AND state_province IS NULL and country IS NULL").each do |team|
      next unless team.members.any?

      team.reverse_geocode

      if team.city.blank?
        m = team.members.first
        team.city = m.city
        team.state_province = m.state_province
        team.country = m.country
      end

      puts "Reverse geocoding Team `#{team.name}`: #{team.primary_location}"

      team.save!
    end
  end
end
