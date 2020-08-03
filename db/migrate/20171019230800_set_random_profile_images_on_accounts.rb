class SetRandomProfileImagesOnAccounts < ActiveRecord::Migration[5.1]
  def up
    Account.
      joins("left outer join regional_ambassador_profiles on regional_ambassador_profiles.account_id = accounts.id").
      where("regional_ambassador_profiles.id IS NULL AND profile_image IS NULL"
    ).find_each do |a|
      a.update_column(
        :icon_path,
        ActionController::Base.helpers.asset_path(
          "placeholders/avatars/#{rand(1..24)}.svg"
        )
      )
    end
  end
end
