class RemoveClubAmbassadorFromMentorProfileTypes < ActiveRecord::Migration[6.1]
  def up
    club_ambassador_mentor_type = MentorType.find_by(name: "Club Ambassador", order: 6)

    club_ambassador_mentor_type.mentor_profile_mentor_types.delete_all
    club_ambassador_mentor_type.delete
  end

  def down
    # NOOP
  end
end
