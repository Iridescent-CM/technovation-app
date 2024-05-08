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

    # execute <<-SQL
    #   CREATE TYPE document_type AS ENUM ('memorandum_of_understanding');
    # SQL

    # add_column :documents, :document_type, :document_type
    add_index :documents, :docusign_envelope_id
  end

  def down
    remove_index :documents, :document_type
    drop_table :documents

    # execute <<-SQL
    #   DROP TYPE document_type;
    # SQL
  end
end
