module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user,
      :current_profile

    def connect
      self.current_user = find_verified_user
      self.current_profile = current_user.admin_profile ||
        current_user.chapter_ambassador_profile
      logger.add_tags 'ActionCable', "Account##{current_user.id}"
    end

    private
    def find_verified_user
      if verified_user = Account.find_by(auth_token: cookies.signed[CookieNames::AUTH_TOKEN])
        verified_user
      else
        reject_unauthorized_connection
      end
    end
  end
end
