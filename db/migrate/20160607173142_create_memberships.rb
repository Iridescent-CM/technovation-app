class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.datetime :approved_at
      t.references :member, index: true, polymorphic: true, null: false
      t.references :joinable, index: true, polymorphic: true, null: false

      t.timestamps null: false
    end
  end
end
