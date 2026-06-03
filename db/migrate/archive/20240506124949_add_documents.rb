class AddDocuments < ActiveRecord::Migration[6.1]
  def up
    create_table :documents do |t|
      t.string :full_name, null: false
      t.string :email_address, null: false
      t.references :signer, polymorphic: true
      t.boolean :active
      t.datetime :signed_at
      t.integer :season_signed, limit: 2
      t.string :docusign_envelope_id, null: false

      t.timestamps
    end

    add_index :documents, :docusign_envelope_id
  end

  def down
    remove_index :documents, :document_type
    drop_table :documents
  end
end
