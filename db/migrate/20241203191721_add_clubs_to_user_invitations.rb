class AddClubsToUserInvitations < ActiveRecord::Migration[6.1]
  def change
    add_reference :user_invitations, :club, foreign_key: true
  end
end
