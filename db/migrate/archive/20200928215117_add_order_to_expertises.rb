class AddOrderToExpertises < ActiveRecord::Migration[5.2]
  def change
    add_column :expertises, :order, :integer
  end
end
