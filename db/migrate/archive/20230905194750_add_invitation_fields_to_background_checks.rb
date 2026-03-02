class AddInvitationFieldsToBackgroundChecks < ActiveRecord::Migration[6.1]
  def change
    add_column :background_checks, :invitation_id, :string
    add_column :background_checks, :invitation_status, :integer
  end
end
