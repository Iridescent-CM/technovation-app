module GetJudgeRole
  def self.call(user)
    user.user_roles.flat_map(&:role).select(&:judge?).first
  end
end
