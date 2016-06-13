class CreateAuthenticationsRoles < ActiveRecord::Migration
  def change
    create_table :authentications_roles, id: false do |t|
      t.belongs_to :authentication, foreign_key: true, index: true
      t.belongs_to :role, foreign_key: true, index: true
    end
  end
end
