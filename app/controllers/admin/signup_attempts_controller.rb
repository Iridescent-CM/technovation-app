module Admin
  class SignupAttemptsController < AdminController
    def index
      params[:status] = "All" if params[:status].blank?
      params[:per_page] = WillPaginate.per_page if params[:per_page].blank?
      params[:page] = 1 if params[:page].blank?

      @signup_attempts = SignupAttempt.send(params[:status].gsub(' ', '_').downcase)
        .where("email LIKE ?", "%#{params[:text].strip}%")
        .page(params[:page].to_i)
        .per_page(params[:per_page].to_i)

      if @signup_attempts.empty?
        @signup_attempts = @signup_attempts.page(1)
      end
    end
  end
end
