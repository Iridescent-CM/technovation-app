class CreateRegionalLinks < ActiveRecord::Migration[5.1]
  def change
    create_table :regional_links do |t|
      t.references :regional_ambassador_profile, foreign_key: true
      t.integer :name
      t.string :value

      t.timestamps
    end
  end
end
