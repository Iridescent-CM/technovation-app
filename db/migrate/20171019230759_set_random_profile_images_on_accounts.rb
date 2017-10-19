class SetRandomProfileImagesOnAccounts < ActiveRecord::Migration[5.1]
  def up
    Account.left_outer_joins(:regional_ambassador_profile).where(
      "regional_ambassador_profiles.id IS NULL AND profile_image IN (?)", ["", nil]
    ).find_each do |a|

      a.update_column(
        :icon_path,
        ActionController::Base.helpers.asset_path(
          "placeholders/avatars/#{rand(1..20)}.svg"
        )
      )

    end
  end
end
