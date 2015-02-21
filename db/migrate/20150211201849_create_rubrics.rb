class CreateRubrics < ActiveRecord::Migration
  def change
    create_table :rubrics do |t|
      t.integer :identify_problem
      t.integer :address_problem
      t.integer :functional
      t.integer :external_resources
      t.integer :match_features
      t.integer :interface
      t.integer :description
      t.integer :market
      t.integer :competition
      t.integer :revenue
      t.integer :branding
      t.integer :pitch
      t.boolean :launch?

      t.timestamps
    end
  end
end
