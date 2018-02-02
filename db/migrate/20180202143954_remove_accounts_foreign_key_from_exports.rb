class RemoveAccountsForeignKeyFromExports < ActiveRecord::Migration[5.1]
  def change
    remove_foreign_key "exports", column: "owner_id"
  end
end
