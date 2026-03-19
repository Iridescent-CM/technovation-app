class AddErrorMessageToBackgroundChecks < ActiveRecord::Migration[6.1]
  def change
    add_column :background_checks, :error_message, :text
  end
end
