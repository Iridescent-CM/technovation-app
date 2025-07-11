class CreateVolunteerAgreements < ActiveRecord::Migration[6.1]
  def change
    create_table :volunteer_agreements do |t|
      t.references :profile, polymorphic: true, index: true
      t.string "electronic_signature", null: false
      t.datetime "voided_at"
      t.timestamps
    end
  end
end
