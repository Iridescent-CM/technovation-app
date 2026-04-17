class CreateLegalContacts < ActiveRecord::Migration[6.1]
  def change
    create_table :legal_contacts do |t|
      t.references :chapter, foreign_key: true
      t.string :full_name, null: false
      t.string :email_address, null: false
      t.string :phone_number
      t.string :job_title

      t.timestamps
    end
  end
end
