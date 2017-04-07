class RenameAccountExportsToExports < ActiveRecord::Migration[4.2]
  def change
    rename_table :account_exports, :exports
  end
end
