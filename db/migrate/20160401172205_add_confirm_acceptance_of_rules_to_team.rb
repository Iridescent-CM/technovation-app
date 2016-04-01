class AddConfirmAcceptanceOfRulesToTeam < ActiveRecord::Migration
  def change
    add_column :teams, :confirm_acceptance_of_rules, :boolean
  end
end
