class UpdatePrimaryLocationOnTeams < ActiveRecord::Migration
  def up
    Team.where(latitude: nil, longitude: nil).find_each do |team|
      team.update_geocoding
      team.save
    end
  end
end
