class AddCustomLabelToRegionalLinks < ActiveRecord::Migration[5.1]
  def change
    add_column :regional_links, :custom_label, :string
  end
end
