module Admin
  class PendingRegionalAmbassadorsController < AdminController
    def index
      @pending_regional_ambassadors = RegionalAmbassadorAccount.pending
    end
  end
end
