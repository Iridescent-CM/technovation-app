class CreateUnconfirmedEmailAddresses < ActiveRecord::Migration[5.1]
  def change
    create_table :unconfirmed_email_addresses do |t|
      t.string :email
      t.references :account, foreign_key: true
      t.string :confirmation_token

      t.timestamps
    end
  end
end
