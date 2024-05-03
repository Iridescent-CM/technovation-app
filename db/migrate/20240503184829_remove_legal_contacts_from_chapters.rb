class RemoveLegalContactsFromChapters < ActiveRecord::Migration[6.1]
  def change
    remove_column :chapters, :legal_contact_full_name
    remove_column :chapters, :legal_contact_email_address
    remove_column :chapters, :legal_contact_phone_number
    remove_column :chapters, :legal_contact_job_title
  end
end
