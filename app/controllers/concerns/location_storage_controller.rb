module LocationStorageController
  extend ActiveSupport::Concern

  included do
    before_action -> {
      StoreLocation.call(ip_address: request.remote_ip,
        context: self,
        account: current_account)
    }
  end
end
