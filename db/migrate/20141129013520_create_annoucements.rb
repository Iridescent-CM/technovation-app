class CreateAnnoucements < ActiveRecord::Migration
  def change
    create_table :annoucements do |t|
      t.string :title
      t.text :post
      t.boolean :published
      t.timestamps
    end
  end
end
