module Admin
  class RegionalAmbassadorsController < AdminController
    def show
      @regional_ambassador = RegionalAmbassadorAccount.find(params.fetch(:id))
      @report = BackgroundCheck::Report.retrieve(@regional_ambassador.background_check_report_id)
      @consent_waiver = @regional_ambassador.consent_waiver
    end
  end
end
