class CreateGlobalInvitations < ActiveRecord::Migration[5.1]
  def change
    create_table :global_invitations do |t|
      t.string :token, null: false
      t.integer :status, null: false, default: 0

      t.timestamps
    end
  end
end
