class AddTimestampsToChapters < ActiveRecord::Migration[6.1]
  def change
    add_column :chapters, :created_at, :datetime
    add_column :chapters, :updated_at, :datetime
  end
end
