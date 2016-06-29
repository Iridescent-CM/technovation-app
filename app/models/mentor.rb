class Mentor < Account
  default_scope { joins(:mentor_profile) }
end
