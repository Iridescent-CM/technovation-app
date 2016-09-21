module Admin
  class RegionalAmbassadorsController < AdminController
    def index
      params[:status] ||= :pending
      @regional_ambassadors = RegionalAmbassadorAccount.public_send(params.fetch(:status))
    end

    def show
      @regional_ambassador = RegionalAmbassadorAccount.find(params.fetch(:id))
      @report = BackgroundCheck::Report.retrieve(@regional_ambassador.background_check_report_id)
      @consent_waiver = @regional_ambassador.consent_waiver
    end

    def update
      ambassador = RegionalAmbassadorAccount.find(params.fetch(:id))
      ambassador.public_send("#{params.fetch(:status)}!")
      redirect_to :back, success: "#{ambassador.full_name} was marked as #{params.fetch(:status)}"
    end
  end
end
