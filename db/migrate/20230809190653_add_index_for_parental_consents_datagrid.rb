class AddIndexForParentalConsentsDatagrid < ActiveRecord::Migration[6.1]
  def change
    add_index :parental_consents, [:seasons, :upload_approval_status]
  end
end
