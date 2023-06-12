class ConvertMentorTypeToMentorTypes < ActiveRecord::Migration[6.1]
  def up
    mentor_types = MentorType.all

    MentorProfile.find_each do |mentor_profile|
      if mentor_profile.mentor_type.present?
        mentor_profile.mentor_types << mentor_types[mentor_profile.mentor_type]

        mentor_profile.save
      end
    end

    remove_column :mentor_profiles, :mentor_type
  end

  def down
    add_column :mentor_profiles, :mentor_type, :integer

    MentorProfile.find_each do |mentor_profile|
      mentor_profile.update_column(:mentor_type, mentor_profile.mentor_types.first)

      mentor_profile.save
    end
  end
end
