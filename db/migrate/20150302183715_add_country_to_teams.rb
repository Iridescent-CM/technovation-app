class AddCountryToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :country, :string, :limit => 2, :null => false, :default => ""
    
    Team.find_each do |team|
      team.country = team.members.group_by(&:home_country).values.max_by(&:size).first.home_country
      team.save!
    end
  end
end
