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
end
