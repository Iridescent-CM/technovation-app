class AddLegalContactsToChapters < ActiveRecord::Migration[6.1]
  def change
    add_column :chapters, :legal_contact_full_name, :string
    add_column :chapters, :legal_contact_email_address, :string
    add_column :chapters, :legal_contact_phone_number, :string
    add_column :chapters, :legal_contact_job_title, :string
  end
end
