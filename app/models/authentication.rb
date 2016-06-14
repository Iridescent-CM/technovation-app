class Authentication < ActiveRecord::Base
  has_secure_password
  has_one :user
  has_many :roles, through: :user

  def self.find_by(*args)
    super(*args) || GuestAuth.new
  end

  class GuestAuth
    def user; Guest.new; end
    def authenticate(*); false; end

    class Guest
      def authenticated?; false; end
    end
  end
end
