class AddSeasonExpiresToDocuments < ActiveRecord::Migration[6.1]
  def change
    add_column :documents, :season_expires, :integer, limit: 2
  end
end
