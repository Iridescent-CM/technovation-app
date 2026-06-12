class AddClubAmbassadorToMentorTypes < ActiveRecord::Migration[6.1]
  def change
    MentorType.create(name: "Club Ambassador", order: 6)
  end
end
