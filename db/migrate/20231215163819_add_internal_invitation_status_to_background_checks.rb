class AddInternalInvitationStatusToBackgroundChecks < ActiveRecord::Migration[6.1]
  def change
    add_column :background_checks, :internal_invitation_status, :integer
  end
end
