class AddOrderToOrganizationTypes < ActiveRecord::Migration[6.1]
  def change
    add_column :organization_types, :order, :integer
  end
end
