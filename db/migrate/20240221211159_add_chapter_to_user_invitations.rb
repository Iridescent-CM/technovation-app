class AddChapterToUserInvitations < ActiveRecord::Migration[6.1]
  def change
    add_reference :user_invitations, :chapter, foreign_key: true
  end
end
