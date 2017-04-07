class CreateAdminProfiles < ActiveRecord::Migration[4.2]
  def change
    create_table :admin_profiles do |t|
      t.references :account, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end
  end
end
