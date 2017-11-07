class RenameAccountToOwnerOnExports < ActiveRecord::Migration[5.1]
  def change
    rename_column :exports, :account_id, :owner_id
    add_column :exports, :owner_type, :string
  end
end
