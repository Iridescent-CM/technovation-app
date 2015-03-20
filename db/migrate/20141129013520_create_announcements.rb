class CreateAnnouncements < ActiveRecord::Migration
  def change
    create_table :announcements do |t|
      t.string :title
      t.text :post
      t.boolean :published
      t.timestamps
    end
  end
end
