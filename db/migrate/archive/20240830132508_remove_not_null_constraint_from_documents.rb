class RemoveNotNullConstraintFromDocuments < ActiveRecord::Migration[6.1]
  def change
    change_column_null :documents, :docusign_envelope_id, true
  end
end
