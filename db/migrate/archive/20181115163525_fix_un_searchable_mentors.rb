class FixUnSearchableMentors < ActiveRecord::Migration[5.1]
  def up
    MentorProfile.current.searchable.find_each do |mentor|
      mentor.save
    end
  end
end
