class AddOnboardedToChapters < ActiveRecord::Migration[6.1]
  def change
    add_column :chapters, :onboarded, :boolean, default: false
  end
end
