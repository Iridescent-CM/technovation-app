class AdminProfile < ActiveRecord::Base
  belongs_to :account
  accepts_nested_attributes_for :account
  validates_associated :account

  has_many :exports, foreign_key: :account_id, dependent: :destroy

  def authenticated?
    true
  end

  def type_name
    "admin"
  end

  def method_missing(method_name, *args)
    begin
      account.public_send(method_name, *args)
    rescue
      raise NoMethodError, "undefined method `#{method_name}' not found for #{self}"
    end
  end
end
