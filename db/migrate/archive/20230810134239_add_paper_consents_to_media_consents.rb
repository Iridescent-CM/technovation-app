class AddPaperConsentsToMediaConsents < ActiveRecord::Migration[6.1]
  def change
    add_column :media_consents, :uploaded_consent_form, :string
    add_column :media_consents, :uploaded_at, :datetime
    add_column :media_consents, :upload_approval_status, :integer, default: 0
    add_column :media_consents, :upload_approved_at, :datetime
    add_column :media_consents, :upload_rejected_at, :datetime
  end
end
