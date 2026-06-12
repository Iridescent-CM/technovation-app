class AddSeasonsToClubs < ActiveRecord::Migration[6.1]
  def change
    add_column :clubs, :seasons, :text, array: true, default: []
  end
end
