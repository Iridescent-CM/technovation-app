class RenameAccountExportsToExports < ActiveRecord::Migration
  def change
    rename_table :account_exports, :exports
  end
end
