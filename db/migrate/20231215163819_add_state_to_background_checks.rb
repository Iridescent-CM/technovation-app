class AddStateToBackgroundChecks < ActiveRecord::Migration[6.1]
  def change
    add_column :background_checks, :state, :integer
  end
end
