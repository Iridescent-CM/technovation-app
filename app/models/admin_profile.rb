class AdminProfile < ActiveRecord::Base
  belongs_to :account

  has_many :exports, foreign_key: :account_id, dependent: :destroy

  def admin?
    true
  end

  def authenticated?
    true
  end
end
