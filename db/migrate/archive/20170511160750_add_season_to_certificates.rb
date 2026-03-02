class AddSeasonToCertificates < ActiveRecord::Migration[5.1]
  def change
    add_column :certificates, :season, :integer
  end
end
