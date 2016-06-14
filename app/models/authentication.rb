class Authentication < ActiveRecord::Base
  has_secure_password
  has_one :user
  has_many :roles, through: :user

  def self.authenticated?(cookies)
    !!authenticate_judge(cookies)
  end

  def self.authenticate_judge(cookies, callbacks = {})
    default_callbacks = { failure: -> { } }.merge(callbacks)
    current_judge(cookies) || default_callbacks.fetch(:failure).call
  end

  def self.current_judge(cookies)
    if !!(@current_judge ||= find_by(auth_token: cookies.fetch(:auth_token, "")))
      @current_judge.user
    else
      false
    end
  end
end
