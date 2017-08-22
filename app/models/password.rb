class Password
  include ActiveModel::Model

  attr_accessor :email,
    :expires_at,
    :password,
    :password_confirmation,
    :token,
    :resetting

  attr_reader :account

  validates :email, exists: true
  validate :valid_password
  validate :not_expired

  def initialize(attrs = {})
    super(attrs)
    @account = !!token && Account.find_by(password_reset_token: token)
    @email ||= !!account && account.email
  end

  def perform
    account.update_attributes({
      skip_existing_password: true,
      password_reset_token: nil,
      password_reset_token_sent_at: nil,
      password: password,
      password_confirmation: password_confirmation
    })
  end

  def self.find_by(attributes)
    if account = Account.find_by(password_reset_token: attributes.fetch(:token))
      new({
        token: account.password_reset_token,
        email: account.email,
        expires_at: account.password_reset_token_sent_at + 2.hours
      })
    else
      new
    end
  end

  private
  def not_expired
    if !!expires_at and expires_at < Time.current
      errors.add(:expires_at, :expired)
    end
  end

  def valid_password
    if !!resetting and password.to_s.length < 8
      errors.add(:password, :too_short, { count: 8 })
    elsif !!resetting and password != password_confirmation
      errors.add(:password_confirmation, :doesnt_match)
    end
  end
end
