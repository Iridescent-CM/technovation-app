class CreateUserRoles < ActiveRecord::Migration
  def change
    create_table :user_roles do |t|
      t.belongs_to :user, foreign_key: true, index: true, null: false
      t.belongs_to :role, foreign_key: true, index: true, null: false
      t.timestamps null: false
    end
  end
end
