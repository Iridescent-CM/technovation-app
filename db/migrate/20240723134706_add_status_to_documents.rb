class AddStatusToDocuments < ActiveRecord::Migration[6.1]
  def up
    execute <<-SQL
      CREATE TYPE document_status AS ENUM ('sent', 'signed', 'voided');
    SQL

    add_column :documents, :status, :document_status
  end

  def down
    remove_column :documents, :status

    execute <<-SQL
      DROP TYPE document_status;
    SQL
  end
end
