module RegisterCoach
  def self.call(coach_account, context)
    coach_account.save
  end

  def self.build(attributes)
    coach = CoachAccount.new(attributes)
    coach.build_coach_profile if coach.coach_profile.blank?
    coach
  end
end
