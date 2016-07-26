class AddProfileImageToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :profile_image, :string
  end
end
