class AdminAccount < Account
  default_scope { joins(:admin_profile) }

  delegate :scores,
           :scored_submission_ids,
    to: :admin_profile, prefix: false

  def admin?
    true
  end

  def profile_id
    admin_profile.id
  end
end
