class AddOrganizationHeadquartersLocationToChapters < ActiveRecord::Migration[6.1]
  def change
    add_column :chapters, :organization_headquarters_location, :string
  end
end
