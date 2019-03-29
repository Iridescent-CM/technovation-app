class RemoveCertificateOverridesFromAccounts < ActiveRecord::Migration[5.1]
  def change
    remove_column :accounts, :override_certificate_type, :integer
  end
end
