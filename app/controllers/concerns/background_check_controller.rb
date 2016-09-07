module BackgroundCheckController
  def new
    if current_account.background_check_candidate_id.present?
      redirect_to [current_account.type_name, :background_check, id: current_account.background_check_candidate_id]
    else
      @candidate = BackgroundCheckCandidate.new(account: current_account)
    end
  end

  def show
    @report = BackgroundCheck::Report.retrieve(current_account.background_check_report_id)

    if @report.status == "clear"
      current_account.complete_background_check!
    end
  end

  def create
    @candidate = BackgroundCheckCandidate.new(candidate_params)

    if @candidate.submit
      current_profile.update_attributes(
        background_check_candidate_id: @candidate.id,
        background_check_report_id: @candidate.report_id
      )
      redirect_to [current_account.type_name, :dashboard],
        success: "Thank you for submitting your background check."
    else
      render :new
    end
  end

  private
  def candidate_params
    params.require(:background_check_candidate)
          .permit(:first_name, :middle_name, :last_name, :email, :zipcode,
                  :date_of_birth, :ssn, :driver_license_state)
  end
end
