class AdminAccount < Account
  default_scope { joins(:admin_profile) }
end
