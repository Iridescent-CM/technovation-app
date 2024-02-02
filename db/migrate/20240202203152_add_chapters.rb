class AddChapters < ActiveRecord::Migration[6.1]
  def change
    create_table :chapters do |t|
      t.string :name
      t.text :summary
      t.string :organization_name
      t.string :city
      t.string :state_province
      t.string :country
    end
  end
end
