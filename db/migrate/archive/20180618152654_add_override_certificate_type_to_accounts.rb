class AddOverrideCertificateTypeToAccounts < ActiveRecord::Migration[5.1]
  def change
    add_column :accounts, :override_certificate_type, :integer
  end
end
