class AddUsesGadgetsToTeamSubmissions < ActiveRecord::Migration[6.1]
  def change
    add_column :team_submissions, :uses_gadgets, :boolean
    add_column :team_submissions, :uses_gadgets_description, :string
  end
end
