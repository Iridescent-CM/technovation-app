class AdminProfile < ActiveRecord::Base
  belongs_to :account
  accepts_nested_attributes_for :account

  has_many :exports, foreign_key: :account_id, dependent: :destroy

  def admin?
    true
  end

  def authenticated?
    true
  end
end
