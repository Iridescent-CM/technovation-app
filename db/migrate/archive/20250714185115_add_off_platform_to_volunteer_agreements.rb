class AddOffPlatformToVolunteerAgreements < ActiveRecord::Migration[6.1]
  def change
    add_column :volunteer_agreements, :off_platform, :boolean, default: false
  end
end
