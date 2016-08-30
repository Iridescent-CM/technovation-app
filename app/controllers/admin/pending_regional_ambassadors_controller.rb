module Admin
  class PendingRegionalAmbassadorsController < AdminController
    def index
      @pending_regional_ambassadors = RegionalAmbassadorAccount.pending
    end

    def update
      ambassador = RegionalAmbassadorAccount.find(params.fetch(:id))
      ambassador.public_send("#{params.fetch(:status)}!")
      redirect_to :back, success: "#{ambassador.full_name} was marked as #{params.fetch(:status)}"
    end
  end
end
