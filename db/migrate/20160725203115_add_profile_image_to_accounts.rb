class AddProfileImageToAccounts < ActiveRecord::Migration[4.2]
  def change
    add_column :accounts, :profile_image, :string
  end
end
