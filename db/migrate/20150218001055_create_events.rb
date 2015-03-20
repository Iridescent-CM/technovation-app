class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.string :location
      t.datetime :whentooccur
      t.string :description

      t.timestamps
    end
  end
end
