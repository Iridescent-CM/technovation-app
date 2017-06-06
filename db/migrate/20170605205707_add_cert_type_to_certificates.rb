class AddCertTypeToCertificates < ActiveRecord::Migration[5.1]
  def change
    add_column :certificates, :cert_type, :integer
  end
end
