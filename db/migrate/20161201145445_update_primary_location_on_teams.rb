class UpdatePrimaryLocationOnTeams < ActiveRecord::Migration[4.2]
  def up
    # out of date!
    #
    #Team.where(latitude: nil, longitude: nil).find_each do |team|
      #team.latitude = team.creator.latitude
      #team.longitude = team.creator.longitude
      #team.save
    #end
  end
end
