module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
      logger.add_tags 'ActionCable', "Account##{current_user.id}"
    end

    private
    def find_verified_user
      if verified_user = Account.find_by(auth_token: cookies.signed[:auth_token])
        verified_user
      else
        reject_unauthorized_connection
      end
    end
  end
end
