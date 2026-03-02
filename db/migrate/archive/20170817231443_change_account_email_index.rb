class ChangeAccountEmailIndex < ActiveRecord::Migration[5.1]
  def up
    remove_index :accounts, :email
    add_index :accounts, :email, unique: true, where: "deleted_at IS NOT NULL"
  end
end
