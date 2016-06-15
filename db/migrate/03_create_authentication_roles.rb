class CreateAuthenticationRoles < ActiveRecord::Migration
  def change
    create_table :authentication_roles do |t|
      t.belongs_to :authentication, foreign_key: true, index: true, null: false
      t.belongs_to :role, foreign_key: true, index: true, null: false
      t.timestamps null: false
    end
  end
end
