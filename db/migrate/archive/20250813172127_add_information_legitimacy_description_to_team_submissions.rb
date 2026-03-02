class AddInformationLegitimacyDescriptionToTeamSubmissions < ActiveRecord::Migration[6.1]
  def change
    add_column :team_submissions, :information_legitimacy_description, :text
  end
end
