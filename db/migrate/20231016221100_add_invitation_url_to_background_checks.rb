class AddInvitationUrlToBackgroundChecks < ActiveRecord::Migration[6.1]
  def change
    add_column :background_checks, :invitation_url, :string
  end
end
