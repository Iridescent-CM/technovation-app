class AddOnboardedToClubs < ActiveRecord::Migration[6.1]
  def change
    add_column :clubs, :onboarded, :boolean, default: false
  end
end
