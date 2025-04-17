class AddSeasonsToChapters < ActiveRecord::Migration[6.1]
  def change
    add_column :chapters, :seasons, :text, array: true, default: []
  end
end
