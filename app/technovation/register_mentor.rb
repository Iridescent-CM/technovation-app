module RegisterMentor
  def self.call(mentor_account, context)
    mentor_account.save
    RegisterToCurrentSeasonJob.perform_later(mentor_account)
  end

  def self.build(model, attributes)
    mentor = model.new(attributes)
    mentor.build_mentor_profile if mentor.mentor_profile.blank?
    mentor
  end
end
