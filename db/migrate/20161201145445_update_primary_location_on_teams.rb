class UpdatePrimaryLocationOnTeams < ActiveRecord::Migration
  def up
    Team.where(latitude: nil, longitude: nil).find_each do |team|
      team.update_columns(latitude: team.creator_latitude,
                          longitude: team.creator_longitude)
    end
  end
end
