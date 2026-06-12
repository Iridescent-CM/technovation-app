class CreateMentorTypes < ActiveRecord::Migration[6.1]
  def change
    create_table :mentor_types do |t|
      t.string :name
      t.integer :order

      t.timestamps
    end
  end
end
