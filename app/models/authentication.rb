class Authentication < ActiveRecord::Base
  has_secure_password
  has_one :user, dependent: :destroy
  has_many :roles, through: :user

  validates :email, presence: true, uniqueness: true

  def judge_user_role
    user.judge_user_role
  end

  def self.authenticated?(cookies)
    exists?(auth_token: cookies.fetch(:auth_token) { "" })
  end

  def self.authenticate_judge(cookies, callbacks = {})
    default_callbacks = { failure: -> { } }.merge(callbacks)
    current_judge(cookies).authenticated? || default_callbacks.fetch(:failure).call
  end

  def self.current_judge(cookies)
    auth = find_by(auth_token: cookies.fetch(:auth_token) { "" })

    if !!auth
      auth.judge_user_role
    else
      NoJudgeFound.new
    end
  end

  class NoJudgeFound
    def authenticated?; false; end
  end
end
