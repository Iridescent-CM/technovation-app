class CreateRegionalPitchEventsUserInvitations < ActiveRecord::Migration[5.1]
  def change
    create_table :regional_pitch_events_user_invitations do |t|
      t.references :regional_pitch_event, foreign_key: true,
        index: {name: "events_invites_event_id"}
      t.references :user_invitation, foreign_key: true,
        index: {name: "events_invites_invite_id"}
    end
  end
end
