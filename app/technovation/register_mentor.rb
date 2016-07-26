module RegisterMentor
  def self.call(mentor_account, context)
    mentor_account.save
  end

  def self.build(attributes)
    mentor = MentorAccount.new(attributes)
    mentor.build_mentor_profile if mentor.mentor_profile.blank?
    mentor
  end
end
