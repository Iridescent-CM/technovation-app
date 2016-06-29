class CreateAdminProfiles < ActiveRecord::Migration
  def change
    create_table :admin_profiles do |t|
      t.references :account, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end
  end
end
