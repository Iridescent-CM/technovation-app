class AddVoidedAtToDocuments < ActiveRecord::Migration[6.1]
  def change
    add_column :documents, :voided_at, :datetime
  end
end
