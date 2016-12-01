class UpdatePrimaryLocationOnTeams < ActiveRecord::Migration
  def up
    Team.where(latitude: nil, longitude: nil).find_each do |team|
      team.latitude = team.creator.latitude
      team.longitude = team.creator.longitude
      team.save
    end
  end
end
