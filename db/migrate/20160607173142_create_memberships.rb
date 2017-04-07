class CreateMemberships < ActiveRecord::Migration[4.2]
  def change
    create_table :memberships do |t|
      t.references :member, index: true, polymorphic: true, null: false
      t.references :joinable, index: true, polymorphic: true, null: false

      t.timestamps null: false
    end
  end
end
