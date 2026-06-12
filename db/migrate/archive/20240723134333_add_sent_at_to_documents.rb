class AddSentAtToDocuments < ActiveRecord::Migration[6.1]
  def change
    add_column :documents, :sent_at, :datetime
  end
end
