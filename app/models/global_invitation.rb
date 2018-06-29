class GlobalInvitation < ApplicationRecord
  enum status: %i{
    active
    deleted
  }

  has_secure_token :token

  def opened!
    # no op
  end

  def email
    ""
  end

  def to_cookie_params
    [CookieNames::GLOBAL_INVITATION_TOKEN, token]
  end

  def self.set_if_exists(profile, token)
    if !!token
      profile.used_global_invitation = active.exists?(token: token)
    else
      false
    end
  end
end
