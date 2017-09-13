class AddSeasonsToAccounts < ActiveRecord::Migration[5.1]
  def change
    add_column :accounts, :seasons, :text, array: true, default: []
    add_column :teams, :seasons, :text, array: true, default: []
    add_column :team_submissions, :seasons, :text, array: true, default: []
  end
end
