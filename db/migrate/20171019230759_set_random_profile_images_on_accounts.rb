class SetRandomProfileImagesOnAccounts < ActiveRecord::Migration[5.1]
  def up
    Account.where(profile_image: ["", nil]).find_each do |a|
      a.update_column(
        :icon_path,
        ActionController::Base.helpers.asset_path(
          "placeholders/avatars/#{rand(1..20)}.svg"
        )
      )
    end
  end
end
