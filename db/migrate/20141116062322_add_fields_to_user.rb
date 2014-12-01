class AddFieldsToUser < ActiveRecord::Migration
  def change
    change_table(:users) do |t|
      # role
      t.integer :role, null: false, default: 0

      # bio
      t.string :first_name, :last_name, null: false
      t.date :birthday, null: false

      # address
      t.string :home_city, :home_state, :postal_code
      t.string :home_country, limit: 2, null: false, default: ""

      # student information
      t.string :school, :grade

      # mentor information
      t.string :salutation
      t.boolean :connect_with_other

      # managed bitwise field
      t.integer :expertise, :null => false, :default => 0
      # order:
      #   t.boolean :science
      #   t.boolean :engineering
      #   t.boolean :project_management
      #   t.boolean :finance
      #   t.boolean :marketing
      #   t.boolean :design

      # parental information
      t.string :parent_first_name, :parent_last_name
      t.string :parent_phone, null: false, default: ""
      t.string :parent_email
      t.datetime :consent_signed_at
      t.datetime :consent_sent_at

      # referral
      t.integer :referral_category
      t.text :referral_details, default: ""
    end
    add_index :users, :parent_email
  end
end
