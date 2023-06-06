class AdminProfile < ActiveRecord::Base
  belongs_to :account
  accepts_nested_attributes_for :account
  validates_associated :account

  has_many :saved_searches, as: :searcher

  has_many :exports, as: :owner, dependent: :destroy

  def authenticated?
    true
  end

  def scope_name
    "admin"
  end

  def rebranded?
    false
  end

  def method_missing(method_name, *args)
    begin
      account.public_send(method_name, *args)
    rescue
      raise NoMethodError,
        "undefined method `#{method_name}' not found for #{self}"
    end
  end

  def make_super_admin!
    update(super_admin: true)
  end
end
